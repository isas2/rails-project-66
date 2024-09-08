class CreateRepositories < ActiveRecord::Migration[7.1]
  def change
    create_table :repositories do |t|
      t.string :name
      t.string :github_id
      t.string :full_name
      t.string :language
      t.string :clone_url
      t.string :ssh_url
      t.references :user, null: false, foreign_key: true, index: true

      t.timestamps
    end
    add_index :repositories, :github_id, unique: true
  end
end
