require 'spec/story'

module StoryHelper
  def ruby(args, stderr)
    config       = ::Config::CONFIG
    interpreter  = File::join(config['bindir'], config['ruby_install_name']) + config['EXEEXT']
    cmd = "#{interpreter} #{args} 2> #{stderr}"
    #puts "\nCOMMAND: #{cmd}"
    `#{cmd}`
  end

  def spec(args, stderr)
    ruby("#{File.dirname(__FILE__) + '/../../../bin/spec'} #{args}", stderr)
  end

  def cmdline(args, stderr)
    ruby("#{File.dirname(__FILE__) + '/../../resources/helpers/cmdline.rb'} #{args}", stderr)
  end
  
  Spec::Story::World.send :include, self
end
