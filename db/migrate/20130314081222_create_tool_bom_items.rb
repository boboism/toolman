class CreateToolBomItems < ActiveRecord::Migration
  def change
    create_table :tool_bom_items do |t|
      t.integer :tool_bom_id
      t.integer :tool_part_id
      t.integer :quantity

      t.timestamps
    end

    add_index :tool_bom_items, :tool_bom_id, name: "tool_bom_items_bom_id"
    add_index :tool_bom_items, :tool_part_id, name: "tool_bom_items_part_id"
  end
end
