class CreateArticles < ActiveRecord::Migration[6.1]
  def change
    create_table :articles do |t|
      t.string :titel
      t.text :body

      t.timestamps
    end
  end
end
