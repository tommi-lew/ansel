class CreateScreenshotsJobs < ActiveRecord::Migration
  def change
    create_table :screenshots_jobs do |t|
      t.string :url_base
      t.string :status, default: 'scheduled'
      t.string :requester

      t.timestamps null: false
    end
  end
end
