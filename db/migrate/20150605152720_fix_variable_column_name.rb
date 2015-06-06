class FixVariableColumnName < ActiveRecord::Migration
  def change
    rename_column :variables, :type, :var_type
  end
end
