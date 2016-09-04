class ScreenshotsJob < ActiveRecord::Base
  STATUSES = %w(scheduled done)

  has_many :browser_stack_jobs, dependent: :destroy

  validates :url_base, :status, :requester, presence: true
  validates :status, inclusion: { in: STATUSES }
  validate :array_attributes_cannot_be_empty
  validates_with UrlValidator, fields: [:url_base]

  def completed?
    self.browser_stack_jobs.where(status: BrowserStackJob.incomplete_states).size == 0
  end

  private

  def browser_ids_cannot_be_empty
    if browser_ids.empty?
      errors.add(:browser_ids, "can't be empty")
    end
  end

  def array_attributes_cannot_be_empty
    if browser_ids.empty?
      errors.add(:browser_ids, "can't be empty")
    end

    if url_paths.empty?
      errors.add(:url_paths, "can't be empty")
    end
  end
end
