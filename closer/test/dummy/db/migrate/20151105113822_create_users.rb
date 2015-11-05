class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :study

      t.timestamps null: false
    end
  end
end
