require 'rails_helper'

describe ScreenshotsJobObserver, observers: :screenshots_job_observer do
  context 'after_create' do
    let(:screenshot_job) { build(:screenshots_job) }

    it 'creates browser stack jobs' do
      mock(BrowserStackService).create_browser_stack_jobs(screenshot_job)
      screenshot_job.save
    end

    it 'request browser stack service to start tracking and managing jobs' do
      stub(BrowserStackService).create_browser_stack_jobs(anything)

      expect(Sidekiq::Extensions::DelayedClass.jobs.size).to eq(0)
      screenshot_job.save
      expect(Sidekiq::Extensions::DelayedClass.jobs.size).to eq(1)
    end
  end
end
