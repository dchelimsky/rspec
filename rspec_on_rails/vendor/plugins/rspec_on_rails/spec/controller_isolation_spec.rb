require File.dirname(__FILE__) + '/spec_helper'

context "a controller spec running in isolation mode", :context_type => :controller do
  controller_name :controller_isolation_spec
  
  specify "should not care if the template doesn't exist" do
    get 'some_action'
    response.should be_success
    response.should render_template("/file/that/does/not/actually/exist")
  end
  
  specify "should not care if the template has errors" do
    get 'action_with_errors_in_template'
    response.should be_success
    response.should render_template("controller_isolation_spec/action_with_errors_in_template")
  end
  
  specify "should not create any templates" do
    get 'some_action'
    response.body.should =~ /\/file\/that\/does\/not\/actually\/exist/
  end
end

context "a controller spec running in integration mode", :context_type => :controller do
  controller_name :controller_isolation_spec
  integrate_views

  specify "should render a template" do
    get 'action_with_template'
    response.should be_success
    response.should have_tag('div','This is action_with_template.rhtml')
  end
  
  specify "should render a template explicitly specified in an action" do
    get 'action_with_specified_template'
    response.should be_success
    response.should have_tag('div',"This template, \"specified_template.rhtml\", is specified by the controller")
  end
  
  # TODO - for some reason these choke in 1.1.6 and edge - and not just choke - they simply cause
  # the process to exit with no information posted to stdout
  #
  # DaC - I've narrowed this down to line 1125 in activerecord/lib/active_record/vendor/mysql.rb (rev 6145):
  #   @sock.flush
  #
  # Also, the line below that calls "get 'some_action'" sets the problem in motion - but ONLY after
  # a spec above w/ the same get is run. If this spec is the only one that gets run, all is well.
  unless ['1.1.6', 'edge'].include?(ENV['RSPEC_RAILS_VERSION'])
    specify "should choke if the template doesn't exist" do
      lambda { get 'some_action' }.should raise_error(ActionView::TemplateError)
      response.should_not be_success
    end
  
    specify "should choke if the template has errors" do
      lambda { get 'action_with_errors_in_template' }.should_raise ActionView::TemplateError
      response.should_not be_success
    end
  end
end

