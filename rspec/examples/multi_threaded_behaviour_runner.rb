
class MultiThreadedBehaviourRunner < Spec::Runner::BehaviourRunner
  def initialize(options, arg)
    super(options)
    # configure these
    @thread_count = 4
    @thread_wait = 0
  end

  def run
    @threads = []
    q = Queue.new
    behaviours.each { |b| q << b}
    success = true
    @thread_count.times do
      @threads << Thread.new(q) do |queue|
        while not queue.empty?
          behaviour = queue.pop
          success &= behaviour.suite.run(nil)
        end
      end
      sleep @thread_wait
    end
    @threads.each {|t| t.join}
    success
  end
end
