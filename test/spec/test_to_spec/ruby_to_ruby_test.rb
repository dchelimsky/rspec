require 'test/unit'
require 'spec/test_to_spec/ruby2ruby'

R2r2r = RubyToRuby.translate(RubyToRuby).sub("RubyToRuby","RubyToRubyToRuby")
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
