module ActiveRecord
  class Base

    (class << self; self; end).class_eval do
      # Extension for should_have on AR Model classes
      #
      #   ModelClass.should_have(:no).records
      #   ModelClass.should_have(1).record
      #   ModelClass.should_have(n).records
      def records
        find(:all)
      end
      alias :record :records
    end

    # Extension for should_have on AR Model instances
    #
    #   model.should_have(:no).errors_on(:attribute)
    #   model.should_have(1).error_on(:attribute)
    #   model.should_have(n).errors_on(:attribute)
    def errors_on(attribute)
      self.valid?
      [self.errors.on(attribute)].flatten.compact
    end
    alias_method :error_on, :errors_on

  end
end

