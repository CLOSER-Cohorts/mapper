class AddUrnToSequences < ActiveRecord::Migration
  def change
    change_table :sequences do |t|
      t.string :URN, index: true
    end    
    add_index :sequences, :URN, :unique => true
  end
end
