class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.references :topic, index: true, foreign_key: true
      t.references :target, index: true, polymorphic: true
      t.timestamps null: false
    end
  end
end
