class AddGridLimitsToQuestion < ActiveRecord::Migration
  def change
    change_table :questions do |t|
      t.integer :max_x
      t.integer :max_y
    end
  end
end
