dir = File.dirname(__FILE__)

require File.expand_path("#{dir}/expectations/opts_merger")
require File.expand_path("#{dir}/expectations/redirect_matcher")
require File.expand_path("#{dir}/expectations/rjs_expectations")
require File.expand_path("#{dir}/expectations/tag_expectations")
require File.expand_path("#{dir}/expectations/render_matcher")
require File.expand_path("#{dir}/expectations/response_body")

module Spec
  module Rails
    # Spec::Rails::Expectations provides Rails-specific extensions to Spec::Expectations
    # (RSpec's core Expectations module)
    #
    # == Active Record Extensions
    #
    # We've added to methods to ActiveRecord::Base to help with specs:
    #
    # The first one is +record+/+records+:
    #
    #   MyModelClass.should have(:no).records
    #   MyModelClass.should have(1).record
    #   MyModelClass.should have(n).records
    #
    # The second is +error_on+/+errors_on+, which you use to specify the number of
    # errors related to a specific attribute:
    #
    #   my_model_instance.should have(:no).errors_on(:attribute_name)
    #   my_model_instance.should have(1).error_on(:attribute_name)
    #   my_model_instance.should have(n).errors_on(:attribute_name)
    #
    # See Spec::Rails::Expectations::Matchers for more information.
    module Expectations
    end
  end
end
