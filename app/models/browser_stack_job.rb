class BrowserStackJob < ActiveRecord::Base
  STATUSES = %w(scheduled queue queued_all done)

  belongs_to :screenshots_job
  has_many :screenshot_results

  validates :status, presence: true, inclusion: { in: STATUSES }
  validates :url_path, presence: true

  scope :scheduled, -> { where(status: 'scheduled') }
  scope :done, -> { where(status: 'done') }
  scope :in_progress, -> { where{ status >> my{in_progress_states} } }

  def self.in_progress_states
    %w(queue queued_all)
  end

  def self.incomplete_states
    %w(scheduled queue queued_all)
  end
end
