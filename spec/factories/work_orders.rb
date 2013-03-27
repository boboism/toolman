# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :work_order do
    tool_bom_id 1
    issued_at "2013-03-14 16:18:18"
    issued_by_id 1
    received_at "2013-03-14 16:18:18"
    received_by_id 1
    tuned_at "2013-03-14 16:18:18"
    tuned_by_id 1
    received false
    tuned false
    grinded false
  end
end
