require 'rails_helper'

describe GenerateScreenshotsJob do
  it 'generate screenshots with screenshots generator' do
    mock.any_instance_of(ScreenshotsGenerator).generate(1)
    subject.perform(1)
  end
end
