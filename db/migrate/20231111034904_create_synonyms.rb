class CreateSynonyms < ActiveRecord::Migration[7.1]
  def change
    create_table :synonyms do |t|
      t.string :words, null: false
      t.timestamps
    end
  end
end
