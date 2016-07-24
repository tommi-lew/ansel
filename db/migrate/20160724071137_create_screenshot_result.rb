class CreateScreenshotResult < ActiveRecord::Migration
  def change
    create_table :screenshot_results do |t|
      t.string :image_url
      t.string :thumbnail_image_url
      t.json :data
      t.references :browser
      t.references :browser_stack_job
      t.timestamps null: false
    end
  end
end
