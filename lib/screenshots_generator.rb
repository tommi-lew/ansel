require 'screenshot'

class ScreenshotsGenerator
  def initialize
    @browser_stack_client = Screenshot::Client.new(
      username: ENV['BROWSERSTACK_USERNAME'],
      password: ENV['BROWSERSTACK_PASSWORD']
    )
  end

  def generate(browser_stack_job_id)
    Rails.logger.info "Generating screenshots for Browser Stack Job ID: #{browser_stack_job_id}"

    browser_stack_job = BrowserStackJob.find(browser_stack_job_id)

    request_id = begin
      @browser_stack_client.generate_screenshots(browser_stack_job.job_params)

    rescue Screenshot::InvalidRequestError
      GenerateScreenshotsJob.perform_in(1.minute, browser_stack_job.id)
    end

    request_state = @browser_stack_client.screenshots_status(request_id)
    browser_stack_job.update_attributes(request_id: request_id, status: request_state)
  end
end
