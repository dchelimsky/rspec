require 'spec'

module DSLExtensions

  def specification(name, &block)
    $default_context ||= Class.new(Spec::Context)
    
    $default_context.add_specification(name.to_sym, &block)
  end

end

class Object
  include DSLExtensions
end

alias example specification if ENV['USER'] == 'marick'
 