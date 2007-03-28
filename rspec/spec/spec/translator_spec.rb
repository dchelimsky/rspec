require File.dirname(__FILE__) + '/../spec_helper.rb'

context "Translator" do
  setup do
    @t = Spec::Translator.new
  end
  
  specify "should translate files" do
    from = File.dirname(__FILE__) + '/..'
    to = File.dirname(__FILE__) + '/../../translated_specs'
    @t.translate_dir(from, to)
  end
  
  specify "should translate should_be_close" do
    @t.translate_line('5.0.should_be_close(5.0, 0.5)').should eql('5.0.should be_close(5.0, 0.5)')
  end

  specify "should translate should_not_raise" do
    @t.translate_line('lambda { self.call }.should_not_raise').should eql('lambda { self.call }.should_not raise_error')
  end

  specify "should translate should_throw" do
    @t.translate_line('lambda { self.call }.should_throw').should eql('lambda { self.call }.should throw_symbol')
  end

  specify "should not translate 0.9 should_not" do
    @t.translate_line('@target.should_not @matcher').should eql('@target.should_not @matcher')
  end

  specify "should leave should_not_receive" do
    @t.translate_line('@mock.should_not_receive(:not_expected).with("unexpected text")').should eql('@mock.should_not_receive(:not_expected).with("unexpected text")')
  end

  specify "should leave should_receive" do
    @t.translate_line('@mock.should_receive(:not_expected).with("unexpected text")').should eql('@mock.should_receive(:not_expected).with("unexpected text")')
  end
  
  specify "should translate multi word predicates" do
    @t.translate_line('foo.should_multi_word_predicate').should eql('foo.should be_multi_word_predicate')
  end

  specify "should translate multi word predicates prefixed with be" do
    @t.translate_line('foo.should_be_multi_word_predicate').should eql('foo.should be_multi_word_predicate')
  end

  specify "should translate be(expected) to equal(expected)" do
    @t.translate_line('foo.should_be :cool').should eql('foo.should equal :cool')
  end

  specify "should translate instance_of" do
    @t.translate_line('5.should_be_an_instance_of(Integer)').should eql('5.should be_an_instance_of(Integer)')
  end

  specify "should translate should_be <" do
    @t.translate_line('3.should_be < 4').should eql('3.should be < 4')
  end

  specify "should translate should_be <=" do
    @t.translate_line('3.should_be <= 4').should eql('3.should be <= 4')
  end

  specify "should translate should_be >=" do
    @t.translate_line('4.should_be >= 3').should eql('4.should be >= 3')
  end

  specify "should translate should_be >" do
    @t.translate_line('4.should_be > 3').should eql('4.should be > 3')
  end

  specify "should translate should_be_happy" do
    @t.translate_line("4.should_be_happy").should eql("4.should be_happy")
  end
    
  specify "should translate custom method taking regexp with parenthesis" do
    @t.translate_line("@browser.should_contain_text(/Sn.rrunger og annet rusk/)").should eql("@browser.should be_contain_text(/Sn.rrunger og annet rusk/)")
  end

  specify "should translate custom method taking regexp without parenthesis" do
    @t.translate_line("@browser.should_contain_text /Sn.rrunger og annet rusk/\n").should eql("@browser.should be_contain_text(/Sn.rrunger og annet rusk/)\n")
  end
   
  specify "should translate should_not_be_nil\n" do
    @t.translate_line("foo.should_not_be_nil\n").should eql("foo.should_not be_nil\n")
  end
    
  specify "should translate kind of" do
    @t.translate_line('@object.should_be_kind_of(MessageExpectation)').should(
    eql('@object.should be_kind_of(MessageExpectation)'))
  end
  
  specify "should translate should_be_true\n" do
    @t.translate_line("foo.should_be_true\n").should eql("foo.should be_true\n")
  end
end