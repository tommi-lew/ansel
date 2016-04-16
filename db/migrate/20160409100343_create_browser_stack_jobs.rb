class CreateBrowserStackJobs < ActiveRecord::Migration
  def change
    create_table :browser_stack_jobs do |t|
      t.json :job_params, default: {}
      t.string :url_path
      t.string :status, default: 'scheduled'
      t.string :request_id
      t.json :result
      t.references :screenshots_job
    end
  end
end
