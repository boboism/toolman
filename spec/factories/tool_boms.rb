# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tool_bom do
    hilt_no "MyString"
    product_line "MyString"
    machine_mode "MyString"
    machine_code "MyString"
    process_position "MyString"
    process_hole "MyString"
    tunning_machine "MyString"
    tunning_mode "MyString"
    tunning_man_hour 1
  end
end
