class CreateEntry < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.string :title
      t.string :url
      t.string :author
      t.text :content
      t.datetime :published
      t.belongs_to :blog
    end
  end
end
