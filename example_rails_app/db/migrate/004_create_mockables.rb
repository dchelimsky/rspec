class CreateMockables < ActiveRecord::Migration
  def self.up
    create_table :mockable_models do |t|
      t.column :name, :string
    end
    create_table :associated_models do |t|
      t.column :mockable_model_id, :integer
    end
  end

  def self.down
    drop_table :mockable_models
    drop_table :associated_models
  end
end
 
