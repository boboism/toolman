class CreateToolBoms < ActiveRecord::Migration
  def change
    create_table :tool_boms do |t|
      t.string :hilt_no, default: ""
      t.string :model, default: ""
      t.string :product_line, default: ""
      t.string :machine_mode, default: ""
      t.string :machine_code, default: ""
      t.string :process_position, default: ""
      t.string :process_hole, default: ""
      t.string :tunning_machine, default: ""
      t.string :tunning_mode, default: ""
      t.integer :tunning_man_hour, default: 0
      t.integer :issue_count, default: 0
      t.integer :grind_count, default: 0
      t.boolean :eng_203_applicable, default: false
      t.boolean :eng_201_applicable, default: false
      t.boolean :eng_185_applicable, default: false
      t.boolean :eng_182_applicable, default: false
      t.boolean :eng_181_applicable, default: false
      t.boolean :eng_161_applicable, default: false

      t.timestamps
    end

    add_index :tool_boms, :hilt_no, name: "tool_boms_hilt_no"
  end
end
