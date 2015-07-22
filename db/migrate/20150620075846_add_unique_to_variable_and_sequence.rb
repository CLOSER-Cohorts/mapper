class AddUniqueToVariableAndSequence < ActiveRecord::Migration
  def change
    add_index :variables, [:name, :instrument_id], :unique => true
    add_index :sequences, [:name, :instrument_id], :unique => true
  end
end
