module ActionView
  class Base
    cattr_accessor :base_view_path
    def render_partial(partial_path, local_assigns = nil, deprecated_local_assigns = nil) #:nodoc:
      if partial_path.is_a?(String)
        unless partial_path.include?("/")
          unless self.class.base_view_path.nil?
            partial_path = "#{self.class.base_view_path}/#{partial_path}"
          end
        end
      end
      super(partial_path, local_assigns, deprecated_local_assigns)
    end
  end
end











