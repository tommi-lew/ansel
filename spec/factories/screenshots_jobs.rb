FactoryGirl.define do
  factory :screenshots_job do
    url_base 'http://www.sephora.sg'
    status 'scheduled'
    sequence(:requester) { |n| "Job Requester #{n}" }
    browser_ids { [create(:browser).id] }
    url_paths { ['/fake_path', '/fake_path2'] }
  end
end
