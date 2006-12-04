module ActiveRecord
  class Base
    (class << self; self; end).class_eval do
      def records
        find(:all)
      end
      alias :record :records
    end
  end
end
