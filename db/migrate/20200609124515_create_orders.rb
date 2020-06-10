class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.integer "member_id",    null: false
      t.integer "payment",      null: false
      t.boolean "delivery",     null: false, default: true
      t.string "postal_code",   null: false
      t.string "address",       null: false
      t.string "address_name",  null: false
      t.string "phone_number",  null: false
      t.timestamps
    end
    add_index :orders, :id
  end
end
