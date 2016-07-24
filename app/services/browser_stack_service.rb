require 'screenshot'

class BrowserStackService
  DELAY_SECONDS = 5

  def initialize(username, password)
    @client = Screenshot::Client.new(
      username: username,
      password: password
    )
  end

  def screenshots_status(request_id)
    @client.screenshots_status(request_id)
  end

  def job_result(request_id)
    @client.screenshots(request_id)
  end

  def update_job(screenshots_job_id)
    ss_job = ScreenshotsJob.find(screenshots_job_id)

    if ss_job.completed?
      ss_job.update(status: 'done')
    else
      self.class.delay_for(DELAY_SECONDS.seconds).check_job(ss_job.id)
    end
  end

  def self.default_api
    BrowserStackService.new(
      ENV['BROWSERSTACK_USERNAME'],
      ENV['BROWSERSTACK_PASSWORD']
    )
  end

  def self.create_browser_stack_jobs(screenshot_job)
    url_paths.each do |path|
      screenshot_job.browser_stack_jobs.create(
        url_path: path,
        job_params: generate_params(screenshot_job, path)
      )
    end
  end

  def self.generate_params(screenshot_job, url_path)
    {
      url: screenshot_job.url_base + url_path,
      callback_url: Rails.application.routes.url_helpers.job_done_api_browser_stack_url(host: ENV['HOST']),
      tunnel: 'false',
      browsers: generate_browsers_params(screenshot_job)
    }
  end

  def self.generate_browsers_params(screenshot_job)
    screenshot_job.browser_ids.map do |browser_id|
      browser = Browser.find(browser_id)

      {
        os: browser.os,
        os_version: browser.os_version,
        browser_version: browser.browser_version,
        device: browser.device,
        browser: browser.browser
      }
    end
  end

  def self.url_paths
    [
      '/',
      '/categories/makeup'
    ]
  end
end
