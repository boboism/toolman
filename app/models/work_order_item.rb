class WorkOrderItem < ActiveRecord::Base
  attr_accessible :grinded, :grinded_at, :grinded_by_id, :quantity, :tool_part_item_id, :work_order_id, :serial_no, :grinding_machine, :grinding_man_hour, :grinding_mode, :tool_bom_item_id

  belongs_to :grinded_by, class_name: "User", foreign_key: "grinded_by_id"
  belongs_to :tool_part_item, class_name: "ToolPartItem", foreign_key: "tool_part_item_id"
  belongs_to :work_order, class_name: "WorkOrder", foreign_key: "work_order_id"
  belongs_to :tool_bom_item, class_name: "ToolBomItem", foreign_key: "tool_bom_item_id"

  scope :search, lambda {|content|
    content = content || {}
    woi     = scoped
    woi     = woi.where{id.in(ToolPartItem.where{serial_no =~ "#{content[:serial_no]}%"}.joins{work_order_items}.select{work_order_items.id})} unless content[:serial_no].blank?

    return woi 
  }
  scope :ungrinded, lambda { where(grinded: false) } 

  def serial_no; tool_part_item ? tool_part_item.serial_no : ""; end
  def serial_no=(value)
    tool_part_item = ToolPartItem.where{serial_no == value}
                                 .includes(:tool_part)
                                 .select("tool_part_items.id, tool_part_items.quantity, tool_parts.grindable").first
    self.tool_part_item_id = tool_part_item.id if tool_part_item && tool_part_item_id
  end

  def grinded_by_name; grinded_by ? grinded_by.name : ""; end
  def grindable?; tool_part_item.tool_part.grindable; end

  def grind(params={})
    ActiveRecord::Base.transaction do
      unless self.work_order.work_order_items.any?{|item| item.id != self.id && !item.grinded}
        self.work_order.grinded = true
        self.work_order.save
      end
      self.update_attributes(params)
    end
  end

end
