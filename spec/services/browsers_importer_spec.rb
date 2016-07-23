require 'rails_helper'

describe BrowsersImporter do
  subject { BrowsersImporter.new }

  describe '#import' do
    def fake_browsers_data(browsers_objects)
      browsers_objects.map do |object|
        {
          os_version: object.os_version,
          browser: object.browser,
          device: object.device,
          browser_version: object.browser_version,
          os: object.os
        }
      end
    end

    it 'imports browsers from browser stack' do
      fake_browsers = build_list(:browser, 2)

      mock.any_instance_of(Screenshot::Client).get_os_and_browsers {
        fake_browsers_data(fake_browsers)
      }

      expect {
        subject.import
      }.to change(Browser, :count).by(2)

      imported_browser = Browser.first
      fake_browser = fake_browsers_data(fake_browsers).first

      expect(imported_browser.os_version).to eq(fake_browser[:os_version])
      expect(imported_browser.browser).to eq(fake_browser[:browser])
      expect(imported_browser.device).to eq(fake_browser[:device])
      expect(imported_browser.browser_version).to eq(fake_browser[:browser_version])
      expect(imported_browser.os).to eq(fake_browser[:os])
    end

    context 'browser exist' do
      it 'does not import' do
        fake_browser = create(:browser)

        mock.any_instance_of(Screenshot::Client).get_os_and_browsers {
          fake_browsers_data([fake_browser])
        }

        expect {
          subject.import
        }.to_not change(Browser, :count)
      end
    end
  end
end
