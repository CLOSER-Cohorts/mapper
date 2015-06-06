class CreateMaps < ActiveRecord::Migration
  def change
    create_table :maps do |t|
      t.references :variable, index: true, foreign_key: true
      t.references :mapable, polymorphic: true, index: true
      t.timestamps null: false
    end
  end
end
