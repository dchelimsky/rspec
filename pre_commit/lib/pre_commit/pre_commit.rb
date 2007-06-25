class PreCommit
  attr_reader :actor
  def initialize(actor)
    @actor = actor
  end

  protected
  def rake_invoke(task_name)
    Rake::Task[task_name].invoke
  end

  def rake_sh(task_name, env_hash={})
    env = env_hash.collect{|key, value| "#{key}=#{value}"}.join(' ')
    rake = (PLATFORM == "i386-mswin32") ? "rake.bat" : "rake"
    output = silent_sh("#{rake} #{task_name} #{env} --trace ") do |line|
      puts line unless line =~ /^running against rails/ || line =~ /^\(in /
    end
    raise "ERROR while running rake: #{output}" if output =~ /ERROR/n || error_code?
  end

  def silent_sh(cmd, &block)
    output = nil
    IO.popen(cmd) do |io|
      output = io.read
      output.each_line do |line|
        block.call(line) if block
      end
    end
    output
  end

  def error_code?
    $? != 0
  end

  def root_dir
    dir = File.dirname(__FILE__)
    File.expand_path("#{dir}/../../..")
  end  

  def method_missing(method_name, *args, &block)
    if actor.respond_to?(method_name)
      actor.send(method_name, *args, &block)
    else
      super
    end
  end
end
