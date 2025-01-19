class CreateContacts < ActiveRecord::Migration[6.1]
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :tax_number
      t.string :phone
      t.string :address_name
      t.string :address_number
      t.string :address_complement
      t.string :postal_code
      t.float :latitude
      t.float :longitude
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
