class ScreenshotsJobObserver < ActiveRecord::Observer
  def after_create(record)
    BrowserStackService.create_browser_stack_jobs(record)
  end
end
