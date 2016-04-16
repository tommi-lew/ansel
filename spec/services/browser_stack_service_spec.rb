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

  describe '#track_and_manage_jobs' do
    let(:ss_job) { create(:screenshots_job) }

    describe 'checks and updates status of queue job' do
      context 'queued job is done' do
        it 'updates status' do
          bs_job = create(:browser_stack_job,
                          screenshots_job: ss_job,
                          status: 'queued_all',
                          request_id: 'request_id_1',
                          job_params: { os: 'Fake OS' }
          )

          stub(subject).screenshots_status('request_id_1') { 'done' }

          subject.track_and_manage_jobs(ss_job)
          expect(bs_job.reload.status).to eq('done')
        end
      end

      context 'queued job is still being processed' do
        it 'does nothing' do
          bs_job = create(:browser_stack_job,
                          screenshots_job: ss_job,
                          status: 'queued_all',
                          request_id: 'request_id_1',
                          job_params: { os: 'Fake OS' }
          )

          stub(subject).screenshots_status('request_id_1') { 'queued_all' }

          subject.track_and_manage_jobs(ss_job)
          expect(bs_job.reload.status).to eq('queued_all')
        end
      end
    end

    context 'has scheduled jobs and no queued jobs' do
      before do
        create_list(
          :browser_stack_job, 2,
          screenshots_job: ss_job,
          job_params: { os: 'Fake OS' }
        )
      end

      it 'starts a job' do
        mock(subject).generate_screenshots_for_job(anything)
        subject.track_and_manage_jobs(ss_job)
      end

      it 'creates a delayed job of itself' do
        stub(subject).generate_screenshots_for_job(anything)

        expect(Sidekiq::Extensions::DelayedClass.jobs.size).to eq(0)
        subject.track_and_manage_jobs(ss_job)
        expect(Sidekiq::Extensions::DelayedClass.jobs.size).to eq(1)
      end
    end

    context 'there is a queued job' do
      before do
        stub(subject).screenshots_status(anything)

        create(:browser_stack_job, screenshots_job: ss_job, job_params: { os: 'Fake OS' })
        create(:browser_stack_job, screenshots_job: ss_job, status: 'queued_all', job_params: { os: 'Fake OS' })
      end

      it 'does nothing and creates a delayed job of itself' do
        expect(Sidekiq::Extensions::DelayedClass.jobs.size).to eq(0)
        subject.track_and_manage_jobs(ss_job)
        expect(Sidekiq::Extensions::DelayedClass.jobs.size).to eq(1)
      end
    end

    context 'all jobs are done' do
      before do
        create_list(
          :browser_stack_job, 2,
          screenshots_job: ss_job,
          status: 'done',
          job_params: { os: 'Fake OS' }
        )
      end

      it 'updates status of screenshots job' do
        subject.track_and_manage_jobs(ss_job)
        expect(ss_job.reload.status).to eq('done')
      end

      it 'does not create delayed job of itself' do
        subject.track_and_manage_jobs(ss_job)
        expect(Sidekiq::Extensions::DelayedClass.jobs.size).to eq(0)
      end
    end
  end

  describe '#generate_screenshots_for_job' do
    it 'generates screenshots for a browser stack job' do
      bs_job = create(:browser_stack_job, job_params: { 'fake_key' => 'fake_value' })

      mock(subject).generate_screenshots(hash_including({ 'fake_key' => 'fake_value' }))
      stub(client).screenshots_status()

      subject.generate_screenshots_for_job(bs_job)
    end
  end

  describe '#generate_screenshots' do
    it 'hits api to generate screenshots' do
      mock(client).generate_screenshots('params')
      subject.generate_screenshots('params')
    end
  end

  describe '#screenshots_status' do
    it 'hits api to get screenshots status' do
      mock(client).screenshots_status('request_id') { 'queued_all' }
      expect(subject.screenshots_status('request_id')).to eq('queued_all')
    end
  end

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

  describe '.track_and_manage_jobs_delayed' do
    it 'calls track_and_manage_jobs' do
      mock(BrowserStackService).default_api.mock!.track_and_manage_jobs(1)
      BrowserStackService.track_and_manage_jobs_delayed(1)
    end
  end

  describe '.create_browser_stack_jobs' do
    it 'creates browser stack jobs' do
      screenshots_job = create(:screenshots_job)
      subject.class.create_browser_stack_jobs(screenshots_job)

      expect(screenshots_job.browser_stack_jobs.size).to eq(subject.class.url_paths.size)
    end
  end

  describe '.generate_params' do
    it 'builds a hash and returns it' do
      params = subject.class.generate_params('http://www.fake.sg', '/foo')

      expect(params[:url]).to eq('http://www.fake.sg/foo')
      expect(params[:callback_url]).to eq('')
      expect(params[:tunnel]).to eq('false')
      expect(params[:browsers]).to eq(subject.class.browsers)
    end
  end

  describe '.browsers' do
    it 'has an array of hashes for each combination of os/browser/device' do
      subject.class.browsers.each do |browser|
        expect(browser).to have_key(:os)
        expect(browser).to have_key(:os_version)
        expect(browser).to have_key(:browser_version)
        expect(browser).to have_key(:device)
        expect(browser).to have_key(:browser)
      end
    end
  end

  describe '.url_paths' do
    it 'contains an array of URL paths' do
      expect(subject.class.url_paths).to be_an(Array)
    end
  end
end
