module RailsIdentifier
  class << self
    def using_legacy_templates?
    	if ActionView::Base.respond_to?(:handler_for_extension) && 
         ActionView::Base.handler_for_extension(:erb) == ActionView::TemplateHandlers::ERB 
           return false
    	end
    	true
    end
  end
end