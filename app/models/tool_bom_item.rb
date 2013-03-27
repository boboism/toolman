class ToolBomItem < ActiveRecord::Base
  attr_accessible :quantity, :tool_bom_id, :tool_part_id

  belongs_to :tool_bom, class_name: "ToolBom", foreign_key: "tool_bom_id"
  belongs_to :tool_part, class_name: "ToolPart", foreign_key:  "tool_part_id"

  has_many :work_order_items, class_name: "WorkOrderItem"
  
  def model; tool_part ? tool_part.model : ""; end
  def grindable; tool_part ? tool_part.grindable : false; end
end
