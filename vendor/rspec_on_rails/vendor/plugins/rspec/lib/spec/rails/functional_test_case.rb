class Spec::Rails::FunctionalTestCase < Spec::Rails::TestCase
  attr_reader :flash, :session
  def setup
    super

    @controller_class = Object.path2class @controller_class_name
    raise "Can't determine controller class for #{self.class}" if @controller_class.nil?

    @controller = @controller_class.new

    @session = ActionController::TestSession.new

    @flash = ActionController::Flash::FlashHash.new
    @session['flash'] = @flash

    @request = ActionController::TestRequest.new
    @request.session = @session

    @response = ActionController::TestResponse.new

    setup_extra if respond_to? :setup_extra
  end

end




