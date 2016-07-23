require 'rails_helper'

describe Api::BrowserStackController do
  describe 'POST job_done' do
    def fake_responses(fake_screenshot_responses, options = {})
      {
        'id' => 'fake_id',
        'browser_stack' => {
          'screenshots' => fake_screenshot_responses
        }
      }.merge(options)
    end

    def fake_screenshot_response(options = {})
      {
        'created_at' => '2016-01-01 23:59:59 UTC',
        'id' => 'fake_id',
        'orientation' => nil,
        'state' => 'done',
        'os_version' => 'os_version',
        'image_url' => 'image_url',
        'browser_version' => 'browser_version',
        'thumb_url' => 'thumb_url',
        'url' => 'url',
        'device' => 'device',
        'os' => 'os',
        'browser' => 'browser'
      }.merge(options)
    end

    it 'creates screenshot result(s)' do
      browser_stack_job = create(:browser_stack_job)
      browser = create(:browser)

      fake_screenshot_response = fake_screenshot_response(browser.attributes.except('id', 'created_at', 'updated_at'))
      fake_response = fake_responses([fake_screenshot_response], 'id' => browser_stack_job.request_id)

      expect {
        xhr :post, :job_done, fake_response
      }.to change(ScreenshotResult, :count).by(1)

      screenshot_result = ScreenshotResult.last

      expect(screenshot_result.image_url).to eq(fake_screenshot_response['image_url'])
      expect(screenshot_result.thumbnail_image_url).to eq(fake_screenshot_response['thumb_url'])

      expect(screenshot_result.browser).to eq(browser)
      expect(screenshot_result.browser_stack_job).to eq(browser_stack_job)
    end

    it "updates status of browser stack job to 'done'" do
      browser_stack_job = create(:browser_stack_job)
      fake_response = fake_responses([], 'id' => browser_stack_job.request_id)

      xhr :post, :job_done, fake_response

      expect(browser_stack_job.reload.status).to eq('done')
    end
  end
end
