class CreateSequences < ActiveRecord::Migration
  def change
    create_table :sequences do |t|
      t.string :name
      t.references :instrument, index: true, foreign_key: true
      t.references :parent, index: true

      t.timestamps null: false
    end
  end
end
