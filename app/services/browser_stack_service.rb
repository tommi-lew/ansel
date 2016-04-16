require 'screenshot'

class BrowserStackService
  DELAY_SECONDS = 5

  def initialize(username, password)
    @client = Screenshot::Client.new(
      username: username,
      password: password
    )
  end

  def track_and_manage_jobs(screenshots_job)
    ss_job = if screenshots_job.is_a?(ScreenshotsJob)
               screenshots_job
             else
               ScreenshotsJob.find(screenshots_job)
             end

    ss_job.browser_stack_jobs.in_progress.each do |job|
      latest_job_status = screenshots_status(job.request_id)
      job.update(status: latest_job_status)
      puts "Latest job status for BSJ #{job.id}: #{latest_job_status}"
    end

    all_jobs = ss_job.browser_stack_jobs
    scheduled_jobs = all_jobs.scheduled.order(id: :asc)
    queued_jobs = all_jobs.where(status: 'queued_all')
    done_jobs = all_jobs.done

    if scheduled_jobs.size > 0 && queued_jobs.size == 0
      Rails.logger.info "SSJ #{ss_job.id} has scheduled jobs and no queued jobs"

      generate_screenshots_for_job(scheduled_jobs.first)
      self.class.delay_for(DELAY_SECONDS.seconds).track_and_manage_jobs_delayed(ss_job.id)

    elsif queued_jobs.size > 0
      Rails.logger.info "SSJ #{ss_job.id} has a queued job"
      self.class.delay_for(DELAY_SECONDS.seconds).track_and_manage_jobs_delayed(ss_job.id)

    elsif all_jobs.size == done_jobs.size
      Rails.logger.info "SSJ #{ss_job.id} is done"
      ss_job.update(status: 'done')
    end
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

  def self.track_and_manage_jobs_delayed(screenshot_job_id)
    BrowserStackService.default_api.track_and_manage_jobs(screenshot_job_id)
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
