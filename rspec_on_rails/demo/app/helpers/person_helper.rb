module PersonHelper
  def say_hello
    "Hello"
  end
  
  def person_address_text_field
    text_field("person", "address")
  end
  
  def label_for_name
    "Name"
  end
  
end
