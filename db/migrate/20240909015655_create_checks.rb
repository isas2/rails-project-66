class CreateChecks < ActiveRecord::Migration[7.1]
  def change
    create_table :repository_checks do |t|
      t.string :commit_id
      t.boolean :result, default: false
      t.text :output
      t.references :repository, null: false, foreign_key: true, index: true

      t.timestamps
    end
  end
end
