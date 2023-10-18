class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :name, null: false, default: ''
      t.string :link, null: false, default: ''
      t.float :average_rating, null: false, default: 0.0
      t.integer :price, null: false, default: 0
      t.string :category, null: false, default: ''

      t.timestamps
    end
  end
end
