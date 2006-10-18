module ActionController
  class TestResponse
    def should_render(expected=nil)
      expected = expected.to_s unless expected.nil?
      rendered = expected ? rendered_file(!expected.include?('/')) : rendered_file
      expected.should == rendered
    end
    
    def should_have_rjs element, *args
      __response_body.should_have_rjs element, *args
    end

    def should_not_have_rjs element, *args
      __response_body.should_not_have_rjs element, *args
    end

    def should_have_tag tag, *opts
      __response_body.should_have_tag tag, *opts
    end

    def should_not_have_tag tag, *opts
      __response_body.should_not_have_tag tag, *opts
    end
    
    private
    def __response_body
      Spec::RailsPlugin::ResponseBody.new(self.body)
    end
  end
end