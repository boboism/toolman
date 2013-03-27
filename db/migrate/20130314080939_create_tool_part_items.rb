class CreateToolPartItems < ActiveRecord::Migration
  def change
    create_table :tool_part_items do |t|
      t.integer :tool_part_id
      t.string :serial_no
      t.integer :quantity
      t.integer :accumulated_grinding_time
      t.integer :accumulated_processing_quantity

      t.timestamps
    end

    add_index :tool_part_items, :tool_part_id, name: "tool_part_items_part_id"
    add_index :tool_part_items, :serial_no, name: "tool_part_items_serial"

  end
end
