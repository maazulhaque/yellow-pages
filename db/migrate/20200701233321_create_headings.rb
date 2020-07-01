class CreateHeadings < ActiveRecord::Migration[6.0]
  def change
    create_table :headings do |t|
      t.string :heading
      t.references :member, null: false, foreign_key: true

      t.timestamps
    end
  end
end
