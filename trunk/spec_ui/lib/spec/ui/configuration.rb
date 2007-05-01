class Spec::DSL::Configuration
  attr_accessor :spec_ui_report_dir
  
  def spec_ui_image_dir
    File.join(spec_ui_report_dir, 'images')
  end
end
