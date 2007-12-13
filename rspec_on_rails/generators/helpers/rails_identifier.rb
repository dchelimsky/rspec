module RailsIdentifier
  class << self
    def using_legacy_templates?
    	# Rails <= 2.0.1
      if    ActionView::Base.const_defined?('DEFAULT_TEMPLATE_HANDLER_PREFERENCE') &&
            ActionView::Base::DEFAULT_TEMPLATE_HANDLER_PREFERENCE.include?(:erb)
         return false
      # Rails > 2.0.1
    	elsif ActionView::Base.respond_to?(:handler_for_extension) && 
            ActionView::Base.handler_for_extension(:erb) == ActionView::TemplateHandlers::ERB then 
    		return false
    	end
    	true
    end
  end
end