class CreateWorkOrderItems < ActiveRecord::Migration
  def change
    create_table :work_order_items do |t|
      t.integer :work_order_id
      t.integer :tool_part_item_id
      t.integer :tool_bom_item_id
      t.integer :quantity
      t.boolean :grinded, default: false
      t.datetime :grinded_at
      t.integer :grinded_by_id
      t.string :grinding_machine
      t.integer :grinding_man_hour
      t.string :grinding_mode

      t.timestamps
    end

    add_index :work_order_items, :work_order_id, name: "work_order_items_order_id"
    add_index :work_order_items, :tool_part_item_id, name: "work_order_items_tpi_id"
    add_index :work_order_items, :grinded, name: "work_order_items_grinded"
  end
end
