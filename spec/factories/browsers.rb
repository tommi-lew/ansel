FactoryGirl.define do
  factory :browser do
    sequence(:os_version) { |n| "OS Version #{n}" }
    sequence(:browser_version) { |n| "Browser Version #{n}" }
    sequence(:os) { |n| "OS #{n}" }
    sequence(:device) { |n| "Device #{n}" }
    sequence(:browser) { |n| "Browser #{n}" }
  end
end
