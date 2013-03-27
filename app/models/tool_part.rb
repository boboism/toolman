class ToolPart < ActiveRecord::Base
  attr_accessible :available_quantity, :category, :grindable, :grinding_machine, :grinding_man_hour, :grinding_time, :machine_quantity, :manufacturer, :material_no, :min_purchase_quantity, :model, :processing_quantity, :specification, :stack_no, :standardized, :stock_current, :stock_max, :stock_min, :stock_no, :sub_category, :supplier, :unit_price, :compansation, :scrapping_length

  has_many :tool_bom_items, class_name: "ToolBomItem"
  has_many :tool_part_items, class_name: "ToolPartItem", dependent: :destroy

  scope :search, lambda { |content|
    content    = content || {}
    tool_parts = scoped
    tool_parts = tool_parts.where{ (model =~ "#{content[:text]}%") | (category =~ "#{content[:text]}%") | (category =~ "#{content[:text]}%") } unless content[:text].blank?
    tool_parts = tool_parts.joins{ tool_part_items }.where{ tool_part_items.serial_no =~ "#{content[:serial_no]}%" } unless content[:serial_no].blank?
    tool_parts = tool_parts.where{ grindable == true} if !!content[:grindable]

    return tool_parts
  }

  def self.import(file)
    spreadsheet = open_spreadsheet(file)
    header      = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row       = Hash[[header, spreadsheet.row(i)].transpose]
      tool_part = where(model: row["model"]).first || new
      tool_part.attributes = row.to_hash.slice(*accessible_attributes)
      tool_part.save!
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

  after_save :synchronize_tool_part_items_with_available_quantity
  def synchronize_tool_part_items_with_available_quantity
    variance = available_quantity - tool_part_items.map(&:quantity).inject(0,&:+) 
    return if variance == 0
    logger.debug "variance= #{variance}"
    if grindable
      if variance < 0  
        tool_part_items.sort!{ |x, y| y.serial_no.scan(/\d+$/) <=> x.serial_no.scan(/\d+$/) }
                       .take(variance.abs)
                       .each(&:destroy)
      else 
        max_index = (tool_part_items.map{ |item| (item.serial_no.scan(/\d+$/)||"0").to_i }.max || [0,]).first
        logger.debug "max_index=#{max_index}"
        (1..variance).each do |i|
          logger.debug "Inserting Item #{model}-#{max_index+i}"
          ToolPartItem.create({ tool_part_id: id, 
                                serial_no: "#{model}-#{max_index+i}",
                                quantity: 1,
                                accumulated_grinding_time: 0,
                                accumulated_processing_quantity: 0 })
        end
      end
    else
      item = tool_part_items.first || ToolPartItem.new
      item.attributes = { tool_part_id: id, 
                          serial_no: model, 
                          quantity: available_quantity, 
                          accumulated_grinding_time: 0,
                          accumulated_processing_quantity: item.accumulated_processing_quantity || 0 }
      item.save
    end
  end
end
