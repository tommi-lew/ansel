class ChangeColumnDefaultOfStatusInScreenshotsJob < ActiveRecord::Migration
  def change
    change_column_default :browser_stack_jobs, :status, 'created_locally'
  end
end
