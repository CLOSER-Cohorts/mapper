class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :qc
      t.string :literal
      t.references :instrument, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
