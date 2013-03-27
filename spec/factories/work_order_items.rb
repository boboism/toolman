# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :work_order_item do
    work_order_id 1
    tool_part_item_id 1
    quantity 1
    grinded false
    grinded_at "2013-03-14 16:19:25"
    grinded_by_id 1
  end
end
