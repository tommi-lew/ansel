require 'rails_helper'

describe ScreenshotResult do
  it { is_expected.to validate_presence_of :image_url }
  it { is_expected.to validate_presence_of :thumbnail_image_url }
  it { is_expected.to validate_presence_of :data }

  it { is_expected.to belong_to :browser }
  it { is_expected.to belong_to :browser_stack_job }
end
