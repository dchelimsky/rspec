$LOAD_PATH.push File.dirname(__FILE__) + '/../..'
require 'spec'

# http://eigenclass.org/hiki.rb?cmd=view&p=instance_exec&key=instance_exec
class Object
  module InstanceExecHelper; end
  include InstanceExecHelper
  def instance_exec(*args, &block) # !> method redefined; discarding old instance_exec
    mname = "__instance_exec_#{Thread.current.object_id.abs}_#{object_id.abs}"
    InstanceExecHelper.module_eval{ define_method(mname, &block) }
    begin
      ret = send(mname, *args)
    ensure
      InstanceExecHelper.module_eval{ undef_method(mname) } rescue nil
    end
    ret
  end
end

class Context
  def initialize(name, &block)
    @name = name
    instance_exec(&block)
  end
  
  def specify(name, &proc)
    Specification.new(name, &proc)
  end
end

class Specification
  def initialize(name, &block)
    @name = name
    instance_exec(&block)
  end
end

module Kernel  
  def context(name, &block)
    Context.new(name, &block)
  end
end