require 'spec'

module DSLExtensions

  def specification(name, &block)
  end

end

class Object
  include DSLExtensions
end
