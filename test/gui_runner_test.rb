require 'test/unit'
require 'socket'
require 'spec'

class PassingCon < Spec::Context

  def ex1
    true.should_be_true
  end

  def ex2
    true.should_be_true
  end

  def ex3
    true.should_be_true
  end

end


class FailingCon < Spec::Context

  def fail1
    false.should_be_true
  end

  def fail2
    false.should_be_true
  end

  def fail3
    false.should_be_true
  end

end


class ErringCon < Spec::Context

  def error1
    raise "boom"
  end

  def error2
    raise "boom"
  end

  def error3
    raise "boom"
  end

end

class SocketListener

	def initialize(port)
	  @server_socket = TCPServer.new("127.0.0.1", port)
		@expectations = Array.new
		@next_expectation_index = 0 
		@expectations_met = false
	end
	
	def shutdown
		@th.kill
		@server_socket.shutdown
	end
	
	def expects(expected_regex)
		@expectations << expected_regex
	end
	
	def verify
		sleep 1
		return if @expectations_met
		msg = "Nothing matching /#{@expectations[@next_expectation_index].source}/ was seen"
		raise  Test::Unit::AssertionFailedError.new(msg)
	end
	
	def run
		@socket = @server_socket.accept
		@th = Thread.new("socket listener") do
			until @expectations_met
				msg, sender = @socket.readline
				msg.chomp!
				next unless @expectations[@next_expectation_index] =~ msg
				@next_expectation_index += 1
				remaining = @expectations.size - @next_expectation_index
				@expectations_met = (remaining == 0)
			end
		end
	end
end

class TestGuiRunner < Test::Unit::TestCase

  def setup
		port = 13001
		@listener = SocketListener.new(port)
		@listener.expects /connected/
    @runner = Spec::GuiRunner.new(port)
  end

	def teardown
		@listener.shutdown
	end

	def test_size_on_start
		@listener.expects /start 3/
		@listener.run
		@runner.run(PassingCon)
		@listener.verify
	end
	
  def test_passing_example_outputs_period
		@listener.expects /start/
		@listener.expects /passed/
		@listener.expects /passed/
		@listener.expects /passed/
		@listener.expects /end/
		@listener.run
    @runner.run(PassingCon)
    @listener.verify
  end

  def test_failing_example_outputs_X
		@listener.expects /start/
		@listener.expects /failed/
		@listener.expects /failed/
		@listener.expects /failed/
		@listener.expects /end/
		@listener.run
    @runner.run(FailingCon)
    @listener.verify
  end

  def test_erring_example_outputs_X
		@listener.expects /start/
		@listener.expects /failed/
		@listener.expects /failed/
		@listener.expects /failed/
		@listener.expects /end/
		@listener.run
    @runner.run(ErringCon)
    @listener.verify
  end
  
  def test_failure_backtrace
		@listener.expects /.*in `fail1'.*/
		@listener.run
    @runner.run(FailingCon)
    @listener.verify
  end

  def test_error_backtrace
		@listener.expects /.*in `error3'.*/
		@listener.run
    @runner.run(ErringCon)
    @listener.verify
  end

end
