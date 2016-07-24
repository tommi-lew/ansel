class AddUrlPathsToScreenshotsJobs < ActiveRecord::Migration
  def change
    add_column :screenshots_jobs, :url_paths, :text, array: true, default: []
  end
end
