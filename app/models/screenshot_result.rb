class ScreenshotResult < ActiveRecord::Base
  validates :image_url, presence: true
  validates :thumbnail_image_url, presence: true
  validates :data, presence: true

  belongs_to :browser
  belongs_to :browser_stack_job
end
