# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :template do
    task_name "MyString"
    task_type "MyString"
    number_to_complete 1
    description "MyString"
    id 1
  end
end
