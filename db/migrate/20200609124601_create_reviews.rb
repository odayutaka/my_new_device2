class CreateReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :reviews do |t|
      t.integer "member_id",  null: false
      t.integer "item_id",    null: false
      t.string "title",       null: false
      t.text "comment",       null: false
      t.timestamps
    end
    add_index :reviews, :id
  end
end
