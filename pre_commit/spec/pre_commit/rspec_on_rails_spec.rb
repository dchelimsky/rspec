require File.dirname(__FILE__) + '/../spec_helper.rb'
require 'fileutils'

include FileUtils

##
# This is not a complete specification of PreCommit.RSpecOnRails, but 
# just a collection of bug fix regression tests.
describe "PreCommit::RSpecOnRails" do
  before do
    @original_dir = File.expand_path(FileUtils.pwd)
    @rails_app_dir = File.expand_path(File.dirname(__FILE__) + "/../../../../../..")

    Dir.chdir(@rails_app_dir)
    @pre_commit = PreCommit::RspecOnRails.new(nil)
  end
  
  describe "pre_commit" do
    after do
      rm('db/migrate/888_create_purchases.rb', :force => true)
      @pre_commit.destroy_purchase
      Dir.chdir(@original_dir)
    end

    # bug in r1802
    it "should fail noisily if there is a migration name conflict" do
      touch('db/migrate/888_create_purchases.rb')
      lambda { @pre_commit.generate_purchase }.should raise_error
    end

    it "should not fail if tests run ok" do
      lambda { @pre_commit.generate_purchase }.should_not raise_error
    end
  end

  describe "rm_generated_purchase_files" do
    before(:each) do
      Dir['db/migrate/*_create_purchases.rb'].each {|f| rm_rf f}
      @pre_commit.generate_purchase
    end
    
    it "should remove the migration file" do
      lambda {
        @pre_commit.rm_generated_purchase_files
      }.should change { Dir['db/migrate/*'].size }.by(-1)
    end
  end
end
