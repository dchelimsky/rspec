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
    @t.translate('5.0.should_be_close(5.0, 0.5)').should eql('5.0.should be_close(5.0, 0.5)')
  end

  specify "should translate should_not_raise" do
    @t.translate('lambda { self.call }.should_not_raise').should eql('lambda { self.call }.should_not raise_error')
  end

  specify "should translate should_throw" do
    @t.translate('lambda { self.call }.should_throw').should eql('lambda { self.call }.should throw_symbol')
  end

  specify "should not translate 0.8 should_not" do
    @t.translate('@target.should_not @matcher').should eql('@target.should_not @matcher')
  end

  specify "should leave should_not_receive" do
    @t.translate('@mock.should_not_receive(:not_expected).with("unexpected text")').should eql('@mock.should_not_receive(:not_expected).with("unexpected text")')
  end

  specify "should leave should_receive" do
    @t.translate('@mock.should_receive(:not_expected).with("unexpected text")').should eql('@mock.should_receive(:not_expected).with("unexpected text")')
  end
  
  specify "should translate multi word predicates" do
    @t.translate('foo.should_multi_word_predicate').should eql('foo.should be_multi_word_predicate')
  end

  specify "should translate multi word predicates prefixed with be" do
    @t.translate('foo.should_be_multi_word_predicate').should eql('foo.should be_multi_word_predicate')
  end

end