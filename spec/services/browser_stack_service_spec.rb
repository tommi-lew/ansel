require 'rails_helper'

describe BrowserStackService do
  subject { BrowserStackService.default_api }
  let(:client) { subject.instance_variable_get(:@client) }

  describe 'scopes' do
    describe '#scheduled'
    describe '#done'
  end

  describe '.initialize' do
    it 'should setup a BrowserStackService' do
      client = subject.instance_variable_get(:@client)
      expect(client).to_not be_nil
    end
  end

  describe '#screenshots_status' do
    it 'hits api to get screenshots status' do
      mock(client).screenshots_status('request_id') { 'queued_all' }
      expect(subject.screenshots_status('request_id')).to eq('queued_all')
    end
  end

  describe '#job_result'

  describe '#update_job' do
    context 'not all browser stack jobs are completed' do
      it 'schedules another background job' do
        ss_job = create(:screenshots_job)

        ss_job.browser_stack_jobs << create_list(
          :browser_stack_job, 2,
          screenshots_job: ss_job,
          job_params: { os: 'Fake OS' }
        )

        expect(Sidekiq::Extensions::DelayedClass.jobs.size).to eq(0)
        subject.update_job(ss_job.id)
        expect(Sidekiq::Extensions::DelayedClass.jobs.size).to eq(1)
      end
    end

    context 'all browser stack jobs are completed' do
      it 'updates screenshot job status' do
        ss_job = create(:screenshots_job)

        ss_job.browser_stack_jobs << create_list(
            :browser_stack_job, 2,
            status: 'done',
            screenshots_job: ss_job,
            job_params: { os: 'Fake OS' }
        )

        subject.update_job(ss_job.id)

        expect(ss_job.reload.status).to eq('done')
      end

      it 'sends an email to the requester'
      it 'sends a notification'
    end
  end

  describe '.default_api' do
    it 'should setup a ZendeskAPI::Client' do
      client = BrowserStackService.default_api.instance_variable_get(:@client)
      expect(client).to_not be_nil
    end
  end

  describe '.create_browser_stack_jobs' do
    it 'creates browser stack jobs' do
      screenshots_job = create(:screenshots_job)
      subject.class.create_browser_stack_jobs(screenshots_job)

      expect(screenshots_job.browser_stack_jobs.size).to eq(screenshots_job.url_paths.size)
    end
  end

  describe '.generate_params' do
    it 'builds a hash and returns it' do
      stub(BrowserStackService).generate_browsers_params { 'fake_browser_params' }

      screenshot_job = build(:screenshots_job)

      params = subject.class.generate_params(screenshot_job, '/foo')

      expect(params[:url]).to eq('http://www.sephora.sg/foo')
      expect(params[:callback_url]).to eq('http://localhost:3000/api/browser_stack/job_done')
      expect(params[:tunnel]).to eq('false')
      expect(params[:browsers]).to eq('fake_browser_params')
    end
  end

  describe '.generate_browsers_params'
end
