class AddParentToQuestions < ActiveRecord::Migration
  def change
    change_table :questions do |t|
      t.references :parent, index: true
    end
  end
end
