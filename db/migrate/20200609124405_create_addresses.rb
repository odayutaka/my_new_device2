class CreateAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :addresses do |t|
      t.integer "member_id",    null: false
      t.string "postal_code",   null: false
      t.string "address",       null: false
      t.string "address_name",  null: false
      t.string "phone_number",  null: false
      t.timestamps
    end
    add_index :addresses, :id
  end
end
