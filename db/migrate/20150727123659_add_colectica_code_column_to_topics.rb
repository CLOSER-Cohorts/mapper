class AddColecticaCodeColumnToTopics < ActiveRecord::Migration
  def change
    change_table :topics do |t|
      t.integer :colecitca_code
    end
  end
end
