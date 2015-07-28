class RenameColecticaCodeColumn < ActiveRecord::Migration
  def change
    rename_column :topics, :colecitca_code, :colectica_code
  end
end
