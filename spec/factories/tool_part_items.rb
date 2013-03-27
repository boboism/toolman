# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tool_part_item do
    tool_part_id 1
    serial_no "MyString"
    quantity 1
    accumulated_grinding_time 1
    accumulated_processing_quantity 1
  end
end
