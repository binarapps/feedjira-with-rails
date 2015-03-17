class CreateBlog < ActiveRecord::Migration
  def change
    create_table :blogs do |t|
      t.text :url
      t.timestamps
    end
  end
end
