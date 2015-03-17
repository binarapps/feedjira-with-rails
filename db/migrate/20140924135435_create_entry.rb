class CreateEntry < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.text :title
      t.text :url
      t.text :author
      t.text :content
      t.datetime :published
      t.belongs_to :blog
    end
  end
end
