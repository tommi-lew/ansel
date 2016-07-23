require 'screenshot'

class BrowserStackService
  DELAY_SECONDS = 5

  def initialize(username, password)
    @client = Screenshot::Client.new(
      username: username,
      password: password
    )
  end

  def generate_screenshots_for_job(browser_stack_job)
    bs_job = if browser_stack_job.is_a?(BrowserStackJob)
               browser_stack_job
             else
               BrowserStackJob.find(browser_stack_job)
             end

    Rails.logger.info "Generating screenshots for Browser Stack Job ID: #{bs_job.id}"

    request_id = generate_screenshots(bs_job.job_params)
    request_state = screenshots_status(request_id)

    puts "Request state for Browser Stack Job #{bs_job.id} is #{request_state}"

    bs_job.update(request_id: request_id, status: 'queued_all')
  end

  def generate_screenshots(params)
    @client.generate_screenshots(params)
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
        job_params: generate_params(screenshot_job.url_base, path)
      )
    end
  end

  def self.generate_params(url_base, url_path)
    {
        url: url_base + url_path,
        callback_url: '',
        tunnel: 'false',
        browsers: browsers
    }
  end

  def self.browsers
    [
      { os: 'Windows', os_version: '8.1', browser_version: '48.0', device: nil, browser: 'chrome' },
      { os: 'Windows', os_version: '8.1', browser_version: '11.0', device: nil, browser: 'ie' },
      { os: 'OS X', os_version: 'Yosemite', browser_version: '49.0', device: nil, browser: 'chrome' },
      { os: 'OS X', os_version: 'Yosemite', browser_version: '8.0', device: nil, browser: 'safari' },
      { os: 'ios', os_version: '8.3', browser_version: nil, device: 'iPhone 6', browser: 'Mobile Safari' },
      { os: 'ios', os_version: '8.3', browser_version: nil, device: 'iPhone 6 Plus', browser: 'Mobile Safari' },
      { os: 'android', os_version: '4.3', browser_version: nil, device: 'Samsung Galaxy Note 3', browser: 'Android Browser' },
      { os: 'ios', os_version: '8.3', browser_version: nil, device: 'iPad Mini 2', browser: 'Mobile Safari' },
      { os: 'ios', os_version: '8.3', browser_version: nil, device: 'iPad Air', browser: 'Mobile Safari' }
    ]
  end

  def self.url_paths
    [
      '/',
      '/categories/makeup'
    ]
  end
end
