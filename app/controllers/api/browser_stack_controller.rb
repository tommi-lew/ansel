class Api::BrowserStackController < ApplicationController
  protect_from_forgery with: :null_session

  def job_done
    browser_stack_request_id = params['id']
    screenshots_data = params.dig('browser_stack', 'screenshots')

    browser_stack_job = BrowserStackJob.find_by(request_id: browser_stack_request_id)

    screenshots_data.each do |screenshot|
      browser = Browser.find_by(screenshot.slice('os_version', 'browser_version', 'os', 'device', 'browser'))

      ScreenshotResult.create(
        image_url: screenshot['image_url'],
        thumbnail_image_url: screenshot['thumb_url'],
        data: screenshot,
        browser_stack_job: browser_stack_job,
        browser: browser
      )
    end

    browser_stack_job.update_attributes(status: 'done')

    head :ok
  end
end
