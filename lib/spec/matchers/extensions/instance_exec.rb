require 'spec/ruby'

module InstanceExec
  if ::Spec::Ruby.version < "1.8.7"
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
end
