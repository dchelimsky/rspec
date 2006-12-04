class CreateAnimals < ActiveRecord::Migration
  def self.up
    create_table :animals do |t|
      t.column :name,      :string, :default => nil
      t.column :person_id, :integer
    end
  end

  def self.down
    drop_table :animals
  end
end
