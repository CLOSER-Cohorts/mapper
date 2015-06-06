class CreateVariables < ActiveRecord::Migration
  def change
    create_table :variables do |t|
      t.string :name
      t.string :label
      t.string :type
      t.references :instrument, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
