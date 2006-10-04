class Object
  def reset_proxied_methods!
    begin
      __method_proxy_space.reset_proxied_methods!
      __notify_reset_proxy_method_listeners
    ensure
      __method_proxy_space.proxied_methods.clear
    end
  end

  private
  def __on_reset_proxied_methods(&listener)
    __reset_proxy_method_listeners << listener
  end

  def __notify_reset_proxy_method_listeners
    __reset_proxy_method_listeners.each do |listener|
      listener.call
    end
  end

  def __reset_proxy_method_listeners
    @__reset_proxy_method_listeners ||= []
  end

  def __method_proxy_space
    ::Spec::MethodProxy::MethodProxySpace.instance
  end

  def __define_proxy_method!(method_name, implementation)
    __method_proxy_space.proxied_methods[method_name] = __method_proxy_space.create_proxy(self, method_name, implementation)
  end
end
