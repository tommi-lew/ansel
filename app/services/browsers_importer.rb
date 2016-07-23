require 'screenshot'

class BrowsersImporter
  def initialize
    @browser_stack_client = Screenshot::Client.new(
      username: ENV['BROWSERSTACK_USERNAME'],
      password: ENV['BROWSERSTACK_PASSWORD']
    )
  end

  def import
    browsers_data = @browser_stack_client.get_os_and_browsers

    browsers_data.each do |browser_data|
      browser_data = browser_data.with_indifferent_access

      Browser.find_or_create_by(
        os_version: browser_data[:os_version],
        browser_version: browser_data[:browser_version],
        os: browser_data[:os],
        device: browser_data[:device],
        browser: browser_data[:browser]
      )
    end
  end
end
