class CreateServings < ActiveRecord::Migration[5.1]
  def change
    create_table :servings do |t|
      t.bigint :operator_id
      t.references :customer, foreign_key: true
      t.integer :status, default: 0

      t.timestamps
    end

    add_index :servings, :operator_id
    add_foreign_key :servings, :users, column: :operator_id
  end
end
