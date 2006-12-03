module Spec
  module Expectations
    module ProcExpectations
      # Given a receiver and a message (Symbol), specifies that the result
      # of sending that message that receiver should change after
      # executing the proc.
      #
      #   lambda { @team.add player }.should_change(@team.players, :size)
      #   lambda { @team.add player }.should_change(@team.players, :size).by(1)
      #   lambda { @team.add player }.should_change(@team.players, :size).to(23)
      #   lambda { @team.add player }.should_change(@team.players, :size).from(22).to(23)
      #
      # You can use a block instead of a message and receiver.
      #
      #   lambda { @team.add player }.should_change{@team.players.size}
      #   lambda { @team.add player }.should_change{@team.players.size}.by(1)
      #   lambda { @team.add player }.should_change{@team.players.size}.to(23)
      #   lambda { @team.add player }.should_change{@team.players.size}.from(22).to(23)
      def should_change(receiver=nil, message=nil, &block)
        should.change(receiver, message, &block)
      end
  
      # Negative of should_change.
      def should_not_change(receiver, message)
        should.not.change(receiver, message)
      end
    end
  end
end

class Proc
  
  include Spec::Expectations::ProcExpectations
end