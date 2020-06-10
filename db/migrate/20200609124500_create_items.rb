class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.integer "genre_id",     null: false
      t.string "name",          null: false
      t.integer "price",        null: false
      t.text "introduction",    null: false
      t.string "item_image_id", null: false
      t.boolean "status",     null: false, default: true
      t.timestamps
    end
    add_index :items, :id
  end
end
