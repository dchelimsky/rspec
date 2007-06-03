module ViewSpecHelper
  def method_in_helper
    "<div>This is text from a method in the ViewSpecHelper</div>"
  end

  def method_in_partial_including_template
    "<div>method_in_partial_including_template in ViewSpecHelper</div>"
  end

  def method_in_included_partial
    "<div>method_in_included_partial in ViewSpecHelper</div>"
  end
end
