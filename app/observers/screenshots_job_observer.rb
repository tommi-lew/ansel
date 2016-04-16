class ScreenshotsJobObserver < ActiveRecord::Observer
  def after_create(record)
    BrowserStackService.create_browser_stack_jobs(record)
    BrowserStackService.delay_for(5.seconds).track_and_manage_jobs_delayed(record.id)
  end
end
