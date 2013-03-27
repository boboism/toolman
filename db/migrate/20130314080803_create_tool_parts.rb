class CreateToolParts < ActiveRecord::Migration
  def change
    create_table :tool_parts do |t|
      t.string :model
      t.string :category
      t.string :sub_category
      t.boolean :standardized
      t.string :specification
      t.integer :machine_quantity
      t.integer :available_quantity
      t.boolean :grindable
      t.integer :grinding_time
      t.integer :processing_quantity
      t.string :grinding_machine
      t.string :grinding_man_hour
      t.string :material_no
      t.string :manufacturer
      t.string :supplier
      t.decimal :unit_price, precision: 18, scale: 2
      t.integer :min_purchase_quantity
      t.string :stock_no
      t.string :stack_no
      t.integer :stock_current
      t.integer :stock_max
      t.integer :stock_min
      t.string :compansation
      t.decimal :scrapping_length, precision: 18, scale: 2

      t.timestamps
    end

    add_index :tool_parts, :model, name: "tool_parts_model"
    add_index :tool_parts, :category, name: "tool_parts_cat"
    add_index :tool_parts, :category, name: "tool_parts_sub_cat"
  end
end
