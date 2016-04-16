FactoryGirl.define do
  factory :browser_stack_job do
    screenshots_job
    sequence(:url_path) { |n| "/path#{n}" }
  end
end
