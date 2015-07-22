class AddGridCoordinatesToMap < ActiveRecord::Migration
  def change
    change_table :maps do |t|
      t.integer :x
      t.integer :y
    end
  end
end
