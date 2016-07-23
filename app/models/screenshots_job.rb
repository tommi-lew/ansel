class ScreenshotsJob < ActiveRecord::Base
  STATUSES = %w(scheduled done)

  has_many :browser_stack_jobs

  validates :url_base, :status, :requester, presence: true
  validates :status, inclusion: { in: STATUSES }
  validate :browser_ids_cannot_be_empty
  validates_with UrlValidator, fields: [:url_base]

  def completed?
    self.browser_stack_jobs.where{ status >> BrowserStackJob.incomplete_states }.size == 0
  end

  private

  def browser_ids_cannot_be_empty
    if browser_ids.empty?
      errors.add(:browser_ids, "can't be empty")
    end
  end
end
