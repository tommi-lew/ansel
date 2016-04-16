FactoryGirl.define do
  factory :screenshots_job do
    url_base 'http://www.sephora.sg'
    status 'scheduled'
    sequence(:requester) { |n| "Job Requester #{n}" }
  end
end
