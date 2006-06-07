# Taken from http://dark.fhtr.org/ruby2ruby.rb

require 'rubygems'
require 'parse_tree'
require 'support'
require 'sexp_processor'


class RubySource < String

  def inspect
    "\n"+to_s
  end

end


class Object

  def parse_tree(method_name=nil)
    if method_name
      m = method(method_name)
      klass = m.defined_in
      method_name = m.name
      return ParseTree.new.parse_tree_for_method(klass, method_name)
    elsif is_a?(Class)
      klass = self
    else
      klass = self.class
    end
    ParseTree.new.parse_tree(klass).first
  end

  def source(method_name=nil)
    RubySource.new RubyToRuby.new.process(parse_tree(method_name))
  end

end


class Method

  def defined_in
    full_name = to_s.split(" ").last.chop
    klass_name = full_name.split(/[\#\.]/).first
    if klass_name.include?("(")
      klass_name = klass_name.split("(").last.chop
    end
    klass = klass_name.split("::").inject(Object){|o,n| o.const_get(n)}
    klass
  end

  def name
    full_name = to_s.split(" ").last.chop
    full_name.split(/[\#\.]/).last
  end

end


class RubyToRuby < SexpProcessor

  def self.translate(klass, method=nil)
    RubySource.new(
      unless method.nil? then
        self.new.process(ParseTree.new.parse_tree_for_method(klass, method))
      else
        self.new.process(ParseTree.new.parse_tree(klass).first) # huh? why is the :class node wrapped?
      end
    )
  end

  def initialize
    super
    @env = Environment.new
    @indent = "  "
    self.auto_shift_type = true
    self.strict = true
    self.expected = String
  end
  
  def indent(s)
    s.to_s.map{|line| @indent + line}.join
  end
  
  def process_and(exp)
    "(#{process exp.shift} and #{process exp.shift})"
  end
  
  def process_args(exp)
    args = []

    until exp.empty? do
      arg = exp.shift
      if arg.is_a? Array
        args[-(arg.size-1)..-1] = arg[1..-1].map{|a| process a}
      else
        args << arg
      end
    end

    return "(#{args.join ', '})"
  end
  
  def process_array(exp)
    code = []
    until exp.empty? do
      code << process(exp.shift)
    end
    return "[" + code.join(", ") + "]"
  end

  def process_attrasgn(exp)
    process_call(exp)
  end

  def process_begin(exp)
    s = "begin\n"
    s << (process(exp.shift).to_s + "\n") until exp.empty?
    s + "\nend"
  end
  
  def process_block(exp)
    code = []
    catch_block_arg = false
    until exp.empty? do
      if catch_block_arg
        if exp.first and exp.first.first == :block_arg
          code[-1] = code[-1][0..-2] + ", #{process(exp.shift)})"
        end
        catch_block_arg = false
      else
        if exp.first.first == :args
          catch_block_arg = true
        end
        if [:ensure, :rescue].include? exp.first.first 
          code << process(exp.shift)
        else
          code << indent(process(exp.shift))
        end
      end
    end

    body = code.join("\n")
    body += "\n"

    return body
  end

  def process_block_arg(exp)
    "&#{exp.shift}"
  end
  
  def process_block_pass(exp)
    bname = process(exp.shift)
    fcall = process(exp.shift)
    if fcall[-1,1] == ')'
      "#{fcall[0..-2]}, &(#{bname}))"
    else
      "#{fcall}(&(#{bname}))"
    end
  end
  
  def process_call(exp)
    receiver = process exp.shift
    name = exp.shift
    args_exp = exp.shift
    if args_exp && args_exp.first == :array
      args = "#{process(args_exp)[1..-2]}"
    else
      args = process args_exp
    end

    case name
    when :<=>, :==, :<, :>, :<=, :>=, :-, :+, :*, :/, :% then #
      "(#{receiver} #{name} #{args})"
    when :[] then
      "#{receiver}[#{args}]"
    else
      "#{receiver}.#{name}#{args ? "(#{args})" : args}"
    end
  end
  
  def process_case(exp)
    s = "case #{process exp.shift}\n"
    until exp.empty?
      pt = exp.shift
      if pt and pt.first == :when
        s << "#{process(pt)}\n"
      else
        s << "else\n#{indent(process(pt))}\n"
      end
    end
    s + "\nend"
  end
  
  def process_class(exp)
    s = "class #{exp.shift} < #{exp.shift}\n"
    body = ""
    body << "#{process exp.shift}\n\n" until exp.empty?
    s + indent(body) + "end"
  end
  
  def process_colon2(exp)
    "#{process(exp.shift)}::#{exp.shift}"
  end
  
  def process_const(exp)
    exp.shift.to_s
  end
  
  def process_dasgn_curr(exp)
    s = exp.shift.to_s 
    s += "=" + process(exp.shift) unless exp.empty?
    s
  end
  
  def process_defn(exp)
    if exp[1].first == :cfunc
      s = "# method '#{exp.shift}' defined in a C function"
      exp.shift
      return s
    else
      name = exp.shift
      args = process(exp.shift)
      return "def #{name}#{args}end".gsub(/\n\s*\n+/, "\n")
    end
  end
  
  def process_dot2(exp)
    "(#{process exp.shift}..#{process exp.shift})"
  end

  def process_dot3(exp)
    "(#{process exp.shift}...#{process exp.shift})"
  end
  
  def process_dstr(exp)
    s = exp.shift.dump[0..-2]
    until exp.empty?
      pt = exp.shift
      if pt.first == :str
        s << process(pt)[1..-2]
      else
        s << '#{' + process(pt) + '}'
      end
    end
    s + '"'
  end

  def process_dvar(exp)
    exp.shift.to_s
  end

  def process_ensure(exp)
    process(exp.shift) + "\n" +
    "ensure\n" +
    indent(process(exp.shift))
  end
  
  def process_false(exp)
    "false"
  end
  
  def process_fbody(exp)
    process(exp.shift)
  end
  
  def process_fcall(exp)
    exp_orig = exp.deep_clone
    # [:fcall, :puts, [:array, [:str, "This is a weird loop"]]]
    name = exp.shift.to_s
    args = exp.shift
    code = []
    unless args.nil? then
      assert_type args, :array
      args.shift # :array
      until args.empty? do
        code << process(args.shift)
      end
    end
    return "#{name}(#{code.join(', ')})"
  end
  
  def process_for(exp)
    s = "for #{process(exp[1])} in #{process(exp[0])}\n"
    2.times{ exp.shift }
    s += indent("#{process(exp.shift)}\n")
    s += "end"
  end
  
  def process_gvar(exp)
    exp.shift.to_s
  end
  
  def process_hash(exp)
    body = []
    body << "#{process(exp.shift)} => #{process(exp.shift)}" until exp.empty?
    body_str = ""
    body_str = "\n"+indent(body.join(",\n"))+"\n" unless body.empty?
    "{" + body_str + "}"
  end
  
  def process_iasgn(exp)
    "#{exp.shift} = #{process exp.shift}"
  end
  
  def cond_indent_process(pt)
    (pt and pt.first == :block) ? process(pt) : indent(process(pt))
  end
  
  def process_if(exp)
    s = ["if (#{process exp.shift})"]
    s << "#{cond_indent_process(exp.shift)}"
    s << "else\n#{cond_indent_process(exp.shift)}" until exp.empty?
    s << "end"
    s.join("\n")
  end
  
  def process_iter(exp)
    "#{process exp.shift} {|#{process exp.shift}|\n" +
    indent("#{process exp.shift}\n") +
    "}"
  end
  
  def process_ivar(exp)
    exp.shift.to_s
  end
  
  def process_lasgn(exp)
    s = "#{exp.shift}" 
    s += " = #{process exp.shift}" unless exp.empty?
    s
  end
  
  def process_lit(exp)
    obj = exp.shift
    if obj.is_a? Range # to get around how parsed ranges turn into lits and lose parens
      "(" + obj.inspect + ")"
    else
      obj.inspect
    end
  end
  
  def process_lvar(exp)
    exp.shift.to_s
  end
  
  def process_masgn(exp)
    process(exp.shift)[1..-2]
  end

  def process_module(exp)
    s = "module #{exp.shift}\n"
    body = ""
    body << "#{process exp.shift}\n\n" until exp.empty?
    s + indent(body) + "end"
  end
  
  def process_nil(exp)
    "nil"
  end
  
  def process_not(exp)
    "(not #{process exp.shift})"
  end
  
  def process_or(exp)
    "(#{process exp.shift} or #{process exp.shift})"
  end
  
  def process_resbody(exp)
    s = "rescue "
    unless exp.empty?
      if exp.first.first == :array
        s << process(exp.shift)[1..-2]
      end
      s << "\n"
    end
    s << (process(exp.shift).to_s + "\n") until exp.empty?
    s
  end
  
  def process_rescue(exp)
    s = ""
    s << (process(exp.shift).to_s + "\n") until exp.empty?
    s
  end
  
  def process_retry(exp)
    "retry"
  end
  
  def process_return(exp)
    return "return #{process exp.shift}"
  end

  def process_scope(exp)
    return process(exp.shift)
  end

  def process_self(exp)
    "self"
  end
  def process_str(exp)
    return exp.shift.dump
  end

  def process_super(exp)
    "super(#{process(exp.shift)})"
  end
  
  def process_true(exp)
    "true"
  end

  def process_until(exp)
    cond_loop(exp, 'until')
  end
  
  def process_vcall(exp)
    return exp.shift.to_s
  end
  
  def process_when(exp)
    "when #{process(exp.shift).to_s[1..-2]}\n#{indent(process(exp.shift))}"
  end

  def process_while(exp)
    cond_loop(exp, 'while')
  end
  
  def process_yield(exp)
    body = process(exp.shift)[1..-2] unless exp.empty?
    "yield#{body and "(#{body})"}"
  end
  
  def process_zarray(exp)
    "[]"
  end

  def process_zsuper(exp)
    "super"
  end
  
  def cond_loop(exp, name)
    cond = process(exp.shift)
    body = cond_indent_process(exp.shift)
    head_controlled = exp.empty? ? false : exp.shift

    code = []
    if head_controlled then
      code << "#{name} (#{cond}) do"
      code << body
      code << "end"
    else
      code << "begin"
      code << body
      code << "end #{name} (#{cond})"
    end
    code.join("\n")
  end
  
end

if __FILE__ == $0
  
  require 'test/unit'
  
  
  R2r2r = RubyToRuby.translate(RubyToRuby).sub("RubyToRuby","RubyToRubyToRuby")
puts R2r2r
exit!1
  eval R2r2r

  
  class RubyToRubyToRuby
    class<<self
      eval RubyToRuby.translate(class<<RubyToRuby;self;end, :translate)
    end
    eval RubyToRuby.translate(RubyToRuby, :initialize)
  end

    
  class R2RTest < Test::Unit::TestCase
  
    def test_self_translation
      r2r2r2 = RubyToRubyToRuby.translate(RubyToRuby).sub("RubyToRuby","RubyToRubyToRuby")
      r2r2r2r = RubyToRubyToRuby.translate(RubyToRubyToRuby)
      # File.open('1','w'){|f| f.write r2r2r}
      # File.open('2','w'){|f| f.write r2r2r2}
      # File.open('3','w'){|f| f.write r2r2r2r}
      assert_equal(R2r2r,r2r2r2)
      assert_equal(R2r2r,r2r2r2r)
    end
    
    def hairy_method(z,x=10,y=20*z.abs,&blok)
      n = 1 + 2 * 40.0 / (z - 2)
      retried = false
      begin
        raise ArgumentError, n if retried
        n -= yield x,y,z,[z,x,y].map(&blok)
        n /= 1.1 until n < 500
        n = "hop hop #{"%.4f" % n}"
        raise n
      rescue RuntimeError => e
        raise if n != e.message
        n = lambda{|i| 
          lambda{|j| "#{i} #{z+2*2} #{j.message.reverse}"
          }
        }[n].call(e)
        unless retried
          retried = true
          retry
        end
      rescue ArgumentError => e
        e.message  
      rescue
      end
    ensure
      x << "ensure a-working"
    end
    
    def foobar a, &block; block.call(a) end
    def k; foobar [1,2,3].each { |x| x*2 } do |x| x*2 end end

    def test_block_predecence_escape
      eval RubyToRuby.translate(self.class, :k).sub(" k"," l")
      assert_equal(k, l)
    end
         
    def test_hairy_method
      eval RubyToRuby.translate(self.class, :hairy_method).sub(" h", " f")
      
      blk = lambda{|x,y,z,arr| 
        unless y
          x.to_i*2
        else
          x.to_i*y*z*arr.inject(1){|s,i| s+i}
        end
      }
      x1 = ""
      x2 = ""
      res = [hairy_method(-5,x1,&blk), fairy_method(-5,x2,&blk)]
      assert_equal(res.first, res.last)
      assert_equal(x1, x2)
      assert_equal("ensure a-working", x1)
    end
    
  end


end
