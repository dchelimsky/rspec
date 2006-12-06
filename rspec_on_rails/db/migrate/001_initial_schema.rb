class InitialSchema < ActiveRecord::Migration
  def self.up
    create_table :people do |t|
      t.column :name, :string, :default => nil
    end
  end

  def self.down
    drop_table :people
  end
end
