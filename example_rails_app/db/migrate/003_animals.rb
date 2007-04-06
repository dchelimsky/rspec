class Animals < ActiveRecord::Migration
  def self.up
    add_column :animals, :age, :float
  end

  def self.down
    remove_column :animals, :age
  end
end
