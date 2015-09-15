class AddStudiesToInstruments < ActiveRecord::Migration
  def change
    change_table :instruments do |t|
      t.string :study
    end
    change_table :users do |t|
      t.string :study
    end
  end
end
