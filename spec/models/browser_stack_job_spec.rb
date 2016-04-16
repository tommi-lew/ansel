require 'rails_helper'

describe ScreenshotsJob do
  subject { build(:browser_stack_job) }

  describe 'scopes'

  it { is_expected.to belong_to :screenshots_job }
  it { is_expected.to validate_inclusion_of(:status).in_array(subject.class::STATUSES) }
  it { is_expected.to validate_presence_of :url_path }

  describe '.in_progress_states'
  describe '.incomplete_states'
end
