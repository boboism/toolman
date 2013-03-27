class WorkOrder < ActiveRecord::Base
  attr_accessible :grinded, :issued_at, :issued_by_id, :received, :received_at, :received_by_id, :tool_bom_id, :tuned, :tuned_at, :tuned_by_id, :hilt_no, :work_order_items_attributes, :tunning_machine, :tunning_mode, :tunning_man_hour

  belongs_to :issued_by, class_name: "User", foreign_key: "issued_by_id"
  belongs_to :received_by, class_name: "User", foreign_key: "received_by_id"
  belongs_to :tuned_by, class_name: "User", foreign_key: "tuned_by_id"
  belongs_to :tool_bom, class_name: "ToolBom", foreign_key: "tool_bom_id"

  has_many :work_order_items, class_name: "WorkOrderItem", :dependent => :destroy
  accepts_nested_attributes_for :work_order_items

  scope :search, lambda { |content| 
    content         = content || {}
    hilt_no         = content[:text]
    serial_no       = content[:serial_no]
    issued_at_start = issued_at_end = nil
    received_at_start = received_at_end = nil
    tuned_at_start = tuned_at_end = nil
    grinded_at_start = grinded_at_end = nil
    begin
      issued_at_start = content[:issued_at_start].to_date
    rescue
    end
    begin
      issued_at_end   = content[:issued_at_end].to_date
    rescue
    end
    begin
      received_at_start = content[:received_at_start].to_date
    rescue
    end
    begin
      received_at_end   = content[:received_at_end].to_date
    rescue
    end
    begin
      tuned_at_start = content[:tuned_at_start].to_date
    rescue
    end
    begin
      tuned_at_end   = content[:tuned_at_end].to_date
    rescue
    end
    begin
      grinded_at_start = content[:grinded_at_start].to_date
    rescue
    end
    begin
      grinded_at_end   = content[:grinded_at_end].to_date
    rescue
    end

    work_orders = scoped.includes([:issued_by, :received_by, :tool_bom])
    work_orders = work_orders.joins{tool_bom}.where{tool_bom.hilt_no == hilt_no} unless hilt_no.blank?
    work_orders = work_orders.joins{ work_order_items.tool_part_item }.where{ work_order_items.tool_part_item.serial_no =~ "#{serial_no}%" } unless serial_no.blank?
    work_orders = work_orders.where{issued_at >= issued_at_start} if issued_at_start
    work_orders = work_orders.where{issued_at < (issued_at_end+1)} if issued_at_end
    work_orders = work_orders.where{received_at >= received_at_start} if received_at_start
    work_orders = work_orders.where{received_at < (received_at_end+1)} if received_at_end
    work_orders = work_orders.where{tuned_at >= tuned_at_start} if tuned_at_start
    work_orders = work_orders.where{tuned_at < (tuned_at_end+1)} if tuned_at_end
    work_orders = work_orders.joins{work_order_items}.where{work_order_items.grinded_at >= grinded_at_start} if grinded_at_start 
    work_orders = work_orders.joins{work_order_items}.where{work_order_items.grinded_at < (grinded_at_end+1)} if grinded_at_end 
    work_orders = work_orders.where{tuned == true} if !!content[:tuned]
    work_orders = work_orders.where{issued == true} if !!content[:issued]
    work_orders = work_orders.where{received == true} if !!content[:received]
    work_orders = work_orders.joins{work_order_items}.where{work_order_items.grinded == true} if !!content[:grinded]
    return work_orders
  }

  scope :unreceived, lambda { where(received: false) }
  scope :received, lambda { where(received: true) }
  scope :untuned, lambda { where(tuned: false) }
  scope :tuned, lambda { where(tuned: true) }
  scope :ungrinded, lambda{ where(grinded: false) }
  scope :grindable, lambda{ joins{work_order_items.tool_part_item.tool_part}.where{work_order_items.tool_part_item.tool_part.grindable == true} }

  def issued_by_name; issued_by || ""; end
  def received_by_name; received_by || ""; end
  def tuned_by_name; tuned_by || ""; end
  
  def receive(params={})
    received_by_id = params[:received_by_id] 
    received_at    = params[:received_at] || DateTime.now
    return false if self.received
    self.received_by_id = received_by_id
    self.received_at    = received_at
    self.received       = true
    self.save
  end

  def tune(params={})
    tuned_by_id = params[:tuned_by_id] 
    tuned_at    = params[:tuned_at] || DateTime.now
    return false if self.tuned
    self.tuned_by_id = tuned_by_id
    self.tuned_at    = tuned_at
    self.tuned       = true
    self.save
  end

  def self.issue(params={})
    hilt_no   = params[:hilt_no]
    issued_at = DateTime.now
    issued_by = User.where(name: params[:issued_by]).first
    return unless issued_by
    serial_nos = params[:work_order_items_attributes].values.map{|item| item[:serial_no]}.keep_if{|item| !item.blank?}
    tool_bom = serial_nos.inject(ToolBom.where(hilt_no: hilt_no)){ |acc, sn| 
      acc.where(id: ToolBom.joins{tool_bom_items.tool_part.tool_part_items}.where{tool_bom_items.tool_part.tool_part_items.serial_no.eq sn}.select{id})
    }.first
    return unless tool_bom
    work_order = new(hilt_no: tool_bom.hilt_no, tool_bom_id: tool_bom.id, issued_at: issued_at, issued_by_id: issued_by.id)
    work_order.work_order_items << tool_bom.tool_bom_items.map do |tbi| 
      if tbi.tool_part.grindable
        tbi.tool_part.tool_part_items.select{ |tpi| serial_nos.include?(tpi.serial_no) }.inject([]) do |acc, tpi|
          acc << WorkOrderItem.new(tool_part_item_id: tpi.id, quantity: 1, tool_bom_item_id: tbi.id)
        end
      else
        WorkOrderItem.new(tool_part_item_id: tbi.tool_part.tool_part_items.first.id, quantity: tbi.quantity, tool_bom_item_id: tbi.id)
      end
    end.flatten
    return work_order.save ? work_order : nil
  end
end
