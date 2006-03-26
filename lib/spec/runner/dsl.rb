
module DSLExtensions

  def context(name)
    eval "$#{name} = Class.new(Spec::Context)"
    $current_context = eval "$#{name}"
  end

  def specification(name, &block)
    $default_context ||= Class.new(Spec::Context)
    $current_context = $default_context if $current_context.nil?

    $current_context.add_specification(name.to_sym, &block)
  end

end

class Object
  include DSLExtensions
end

alias example specification if ENV['USER'] == 'marick'
