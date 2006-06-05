# Install hook code here
require 'fileutils'
include FileUtils

here = File.dirname(__FILE__)
spec_dir = File.expand_path("#{here}/../../../spec")

mkdir_p "#{spec_dir}/unit"
mkdir_p "#{spec_dir}/functional"
mkdir_p "#{spec_dir}/fixtures"

cp( "#{here}/files/spec_helper.rb", "#{spec_dir}/spec_helper.rb" ) unless File.exist? "#{spec_dir}/spec_helper.rb"
