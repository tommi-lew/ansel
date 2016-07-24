class GenerateScreenshotsJob
  include Sidekiq::Worker

  def perform(browser_stack_job_id)
    ScreenshotsGenerator.new.generate(browser_stack_job_id)
  end
end
