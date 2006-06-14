require 'rubygems'
require 'parse_tree'
require 'spec/test_to_spec/sexp_transformer'
require 'spec/test_to_spec/ruby2ruby'

module Test
  module Unit
    class TestCase
      # Returns a String representing the RSpec translation of this class
      def self.to_rspec
        tree = ParseTree.new.parse_tree(self).first
        rspec_tree = Spec::TestToSpec::SexpTransformer.new.process(tree)
        modules = self.name.split("::")[0..-2]
        result = ""
        result += modules.collect{|m| "module #{m}\n"}.join("")
        result += RubyToRuby.new.process(rspec_tree[0])
        result += modules.collect{|m| "\nend"}.join("")
        result
      end
    end
  end
end