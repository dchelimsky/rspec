module Spec
  module Mocks
    class Space
      def add(obj)
        mocks << obj unless mocks.detect {|m| m.equal? obj}
      end

      def add_mocked_class(klass, double)
        mocked_classes[double] = klass
        Object.__send__(:remove_const, klass.name)
        Object.__send__(:const_set, klass.name, double)
      end

      def restore_mocked_class(double)
        orig_klass = mocked_classes[double]
        return unless orig_klass
        Object.__send__(:remove_const, orig_klass.name)
        Object.__send__(:const_set, orig_klass.name, orig_klass)
      end

      def verify_all
        mocks.each do |mock|
          mock.rspec_verify
        end
      end

      def reset_all
        reset_mocks
        reset_mocked_classes
      end

    private

      def mocks
        @mocks ||= []
      end

      def mocked_classes
        @mocked_classes ||= {}
      end

      def reset_mocks
        begin
          mocks.each do |mock|
            mock.rspec_reset
          end
        ensure
          mocks.clear
        end
      end

      def reset_mocked_classes
        begin
          mocked_classes.keys.each {|double| restore_mocked_class(double) }
        ensure
          mocked_classes.clear
        end
      end
    end
  end
end
