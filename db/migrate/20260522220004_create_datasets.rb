class CreateDatasets < ActiveRecord::Migration[8.1]
  def change
    create_table :datasets do |t|
      t.string :external_id, null: false
      t.string :title,       null: false
      t.jsonb  :authors,     null: false, default: []
      t.jsonb  :keywords,    null: false, default: []
      t.timestamps
    end

    add_index :datasets, :external_id, unique: true
    add_index :datasets, "lower(title)", unique: true, name: "index_datasets_on_lower_title"
    add_index :datasets, :keywords, using: :gin
  end
end

