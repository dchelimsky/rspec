module ActionController
  class Base
    class << self
      def set_view_path(path)
        method = respond_to?(:view_paths=) ? :view_paths= : :template_root=
        send(method, path)
      end
    end
  end
end
        
