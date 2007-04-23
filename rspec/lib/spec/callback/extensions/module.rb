module Callback
  module ModuleMethods
    # For each event_name submitted, defines a callback event with this name.
    # Client code can then register as a callback listener using object.event_name.
    def callback_events(*event_names)
      event_names.each do |event_name|
        define_callback_event(event_name)
      end
    end

    private
    def define_callback_event(event_name)
      eval_text = <<-EOS
        def #{event_name}(&block)
          register_callback(:#{event_name}, &block)
        end
      EOS
      module_eval eval_text, __FILE__, (__LINE__-6) 
    end
  end
end

class Module
  include Callback::ModuleMethods
end
