class ToolPartItem < ActiveRecord::Base
  attr_accessible :accumulated_grinding_time, :accumulated_processing_quantity, :quantity, :serial_no, :tool_part_id

  belongs_to :tool_part, class_name: "ToolPart", foreign_key: "tool_part_id"

  has_many :work_order_items, class_name: "WorkOrderItem"
end
