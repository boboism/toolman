class CreateWorkOrders < ActiveRecord::Migration
  def change
    create_table :work_orders do |t|
      t.string :hilt_no
      t.integer :tool_bom_id
      t.datetime :issued_at
      t.integer :issued_by_id
      t.datetime :received_at
      t.integer :received_by_id
      t.datetime :tuned_at
      t.integer :tuned_by_id
      t.boolean :received, default: false
      t.boolean :tuned, default: false
      t.boolean :grinded, default: false
      t.string :tunning_machine, default: ""
      t.string :tunning_mode, default: ""
      t.string :tunning_man_hour, default: 0

      t.timestamps
    end

    add_index :work_orders, :tool_bom_id, name: "work_orders_bom_id"
    add_index :work_orders, :tuned, name: "work_orders_tuned"
    add_index :work_orders, :received, name: "work_orders_received"
    add_index :work_orders, :grinded, name: "work_orders_grinded"

  end
end
