class AddBrowserIdsToScreenshotJobs < ActiveRecord::Migration
  def change
    add_column :screenshots_jobs, :browser_ids, :text, array: true, default: []
  end
end
