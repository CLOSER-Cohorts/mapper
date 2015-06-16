class AddUniqueQcToQuestion < ActiveRecord::Migration
  def change
    add_index :questions, [:qc, :instrument_id], :unique => true
  end
end
