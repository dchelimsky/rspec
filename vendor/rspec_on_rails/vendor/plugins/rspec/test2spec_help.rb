# Adds the same helper methods as Rails' test_help.rb
# This file must be required from test_helper.rb
# before running test2spec over Rails tests.
class Test::Unit::TestCase
  def self.fixture_path=(p)
  end
  
  def self.fixture_table_names=(*args)
  end

  def self.fixture_class_names=(*args)
  end

  def self.use_transactional_fixtures=(*args)
  end

  def self.use_instantiated_fixtures=(*args)
  end

  def self.pre_loaded_fixtures=(*args)
  end
  
  def self.fixtures(*table_names)  
  end
end