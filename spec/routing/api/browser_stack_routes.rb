require 'rails_helper'

describe 'routes for Api::BrowserStack' do
  it 'should route to api/browser_stack#job_done' do
    expect(
      post: '/api/browser_stack/job_done'
    ).to route_to(controller: 'api/browser_stack', action: 'job_done')
  end
end
