require 'rails_helper'

describe ScreenshotsGenerator do
  subject { ScreenshotsGenerator.new }
  let(:client) { subject.instance_variable_get(:@browser_stack_client) }

  describe '#generate' do
    it 'hits browser stack to generate screenshots' do
      stub(client).screenshots_status
      mock(client).generate_screenshots(hash_including({ 'fake_key' => 'fake_value' }))

      job = create(:browser_stack_job, job_params: { 'fake_key' => 'fake_value' })

      subject.generate(job.id)
    end

    context 'invalid request error' do
      it 'schedules a generate screenshot worker to be ran in 1 minute' do
        stub(client).screenshots_status
        stub(client).generate_screenshots { raise Screenshot::InvalidRequestError }

        job = create(:browser_stack_job, job_params: { 'fake_key' => 'fake_value' })

        expect {
          subject.generate(job.id)
        }.to change(GenerateScreenshotsJob.jobs, :size).by(1)
      end
    end

    it 'updates status of browser stack job' do
      job = create(:browser_stack_job, job_params: { 'fake_key' => 'fake_value' })

      stub(client).screenshots_status { 'queue' }
      stub(client).generate_screenshots

      subject.generate(job.id)

      expect(job.reload.status).to eq('queue')
    end
  end
end
