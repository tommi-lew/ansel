require 'rails_helper'

describe ScreenshotsJob do
  subject { build(:screenshots_job) }

  it { is_expected.to have_many :browser_stack_jobs }
  it { is_expected.to validate_presence_of :url_base }
  it { is_expected.to validate_presence_of :requester }
  it { is_expected.to validate_inclusion_of(:status).in_array(subject.class::STATUSES) }

  describe 'validations' do
    describe 'url_base' do
      it 'has valid url' do
        subject.url_base = 'http://www.sephora.sg'
        expect(subject).to be_valid

        subject.url_base = 'sephora'
        expect(subject).to_not be_valid

        # subject.url_base = 'http://www.sephora'
        # expect(subject).to_not be_valid
      end
    end
  end

  describe '#completed?' do
    context 'all browser stack jobs done' do
      it 'returns true' do
        subject.save
        BrowserStackService.create_browser_stack_jobs(subject)
        subject.browser_stack_jobs.update_all(status: 'done')

        expect(subject.completed?).to be_truthy
      end
    end

    context 'not all browser stack jobs done' do
      it 'returns false' do
        subject.save
        BrowserStackService.create_browser_stack_jobs(subject)
        subject.browser_stack_jobs.first.update(status: 'done')

        expect(subject.completed?).to be_falsy
      end
    end
  end
end
