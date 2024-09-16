class ChangeCheckColumnName < ActiveRecord::Migration[7.1]
  def change
    rename_column :repository_checks, :result, :passed
  end
end
