module ActionController
  class Base
    class << self
      def set_view_path(path)
        send (respond_to?(:view_paths=) ? :view_paths= : :template_root=), path
      end
    end
  end
end
        