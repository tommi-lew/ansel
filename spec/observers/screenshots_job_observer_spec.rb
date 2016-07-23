require 'rails_helper'

describe ScreenshotsJobObserver, observers: :screenshots_job_observer do
  context 'after_create' do
    let(:screenshot_job) { build(:screenshots_job) }

    it 'creates browser stack jobs' do
      mock(BrowserStackService).create_browser_stack_jobs(screenshot_job)
      screenshot_job.save
    end
  end
end
