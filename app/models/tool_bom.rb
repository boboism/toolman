class ToolBom < ActiveRecord::Base
  attr_accessible :hilt_no, :machine_code, :machine_mode, :process_hole, :process_position, :product_line, :tunning_machine, :tunning_man_hour, :tunning_mode, :tool_bom_items_attributes, :model, :eng_203_applicable, :eng_201_applicable, :eng_185_applicable, :eng_182_applicable, :eng_181_applicable, :eng_161_applicable

  has_many :tool_bom_items, class_name: "ToolBomItem", dependent: :destroy
  accepts_nested_attributes_for :tool_bom_items

  scope :search, lambda { |content|
    content = content || {}
    where('hilt_no like :text', {text: content[:text]}) unless content[:text].blank?
  }

  before_save :calculate_issue_count
  def calculate_issue_count
    self.issue_count = tool_bom_items.inject(0){|acc, item| acc += item.tool_part.grindable ? item.quantity : 1}
  end

  before_save :calculate_grind_count
  def calculate_grind_count
    self.grind_count = tool_bom_items.inject(0){|acc, item| acc += item.tool_part.grindable ? item.quantity : 0}
  end

  def self.import(file)
    spreadsheet = open_spreadsheet(file)
    header      = spreadsheet.row(1)
    item_header = header.select{|k| k.to_s =~ /tool_bom_items\./ }
    #logger.debug header

    (3..spreadsheet.last_row).each do |i|
      #logger.debug spreadsheet.row(i).count 
      logger.debug "HEADER: #{header}"
      logger.debug "ITEM HEADER: #{item_header}"
      row      = Hash[[header, spreadsheet.row(i)].transpose]
      #debugger
      tool_bom = where(hilt_no: row["hilt_no"]).first || new
      tool_bom.attributes = row.to_hash.slice(*accessible_attributes)

      tool_part = ToolPart.where(model: row["tool_bom_items.model"]).select{id}.first
      next unless tool_bom && tool_part
      tool_bom_item_attributes = {tool_bom_id: tool_bom.id, tool_part_id: tool_part.id}
      tool_bom_item = ToolBomItem.where(tool_bom_item_attributes).first || ToolBomItem.new(tool_bom_item_attributes)
      tool_bom_item.attributes = row.to_hash.slice(*item_header)
                                            .inject({}){|acc, (k,v)| acc.merge({ k.scan(/tool_bom_items\.(\w+)$/).flatten.first => v})}
                                            .slice(*ToolBomItem.accessible_attributes)
      tool_bom.tool_bom_items << tool_bom_item if tool_bom_item.new_record?
      logger.debug tool_bom_item.inspect
      tool_bom.save!
    end
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when ".csv" then Roo::Csv.new(file.path, nil, :ignore)
    when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
    when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
    else raise I18n.t('helpers.files.unsupport_file_type', name: file.original_filename)
    end
  end

end
