class CreateInstruments < ActiveRecord::Migration
  def change
    create_table :instruments do |t|
      t.string :prefix
      t.string :port

      t.timestamps null: false
    end
  end
end
