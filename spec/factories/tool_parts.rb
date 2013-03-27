# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tool_part do
    model "MyString"
    category "MyString"
    sub_category "MyString"
    standardized false
    specification "MyString"
    machine_quantity 1
    available_quantity 1
    grindable false
    grinding_time 1
    processing_quantity 1
    grinding_machine "MyString"
    grinding_man_hour "MyString"
    material_no "MyString"
    manufacturer "MyString"
    supplier "MyString"
    unit_price ""
    min_purchase_quantity 1
    stock_no "MyString"
    stack_no "MyString"
    stock_current 1
    stock_max 1
    stock_min 1
  end
end
