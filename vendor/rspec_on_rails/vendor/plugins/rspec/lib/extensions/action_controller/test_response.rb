module ActionController
  class TestResponse
    def should_render(expected=nil)
      expected = expected.to_s unless expected.nil?
      rendered = expected ? rendered_file(!expected.include?('/')) : rendered_file
      expected.should_equal rendered
    end
    
    def should_have_rjs element, *args
      Spec::RailsPlugin::ResponseBody.new(self.body).should_have_rjs element, *args
    end

    def should_not_have_rjs element, *args
      Spec::RailsPlugin::ResponseBody.new(self.body).should_not_have_rjs element, *args
    end

    def should_have_tag tag, *opts
      Spec::RailsPlugin::ResponseBody.new(self.body).should_have_tag tag, *opts
    end

    def should_not_have_tag tag, *opts
      Spec::RailsPlugin::ResponseBody.new(self.body).should_not_have_tag tag, *opts
    end
  end
end