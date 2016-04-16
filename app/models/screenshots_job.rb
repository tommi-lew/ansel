class ScreenshotsJob < ActiveRecord::Base
  STATUSES = %w(scheduled done)

  has_many :browser_stack_jobs
  validates :url_base, :status, :requester, presence: true
  validates :status, inclusion: { in: STATUSES }
  validates_with UrlValidator, fields: [:url_base]

  def completed?
    self.browser_stack_jobs.where{ status >> BrowserStackJob.incomplete_states }.size == 0
  end
end
