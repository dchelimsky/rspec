require File.dirname(__FILE__) + '/../spec_helper'

describe "script/spec_server file" do
  before do
    dir = "#{Dir.tmpdir}/#{Time.now.to_i}"
    spec_server_pid_file = "#{dir}/spec_server.pid"
    FileUtils.mkdir_p dir
    system "touch #{spec_server_pid_file}"
    cmd = %Q|ruby -e 'system("echo " + Process.pid.to_s + " > #{spec_server_pid_file}"); load "#{RAILS_ROOT}/script/spec_server"' &|
    system cmd

    file_content = ""
    Timeout.timeout(5) do
      loop do
        file_content = File.read(spec_server_pid_file)
        break unless file_content.blank?
      end
    end
    @pid = Integer(File.read(spec_server_pid_file))
  end

  after do
    system "kill -9 #{@pid}"
  end

  it "should run a spec" do
    pending("this doesn't seem to work consistently")
    dir = File.dirname(__FILE__)
    output = ""
    Timeout.timeout(5) do
      loop do
        output = `#{RAILS_ROOT}/script/spec #{dir}/sample_spec.rb --drb 2>&1`
        break unless output.include?("No server is running")
      end
    end

    unless $?.exitstatus == 0
      flunk "command 'script/spec spec/sample_spec' failed\n#{output}"
    end
  end
end