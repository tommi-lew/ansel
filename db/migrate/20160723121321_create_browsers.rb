class CreateBrowsers < ActiveRecord::Migration
  def change
    create_table :browsers do |t|
      t.string :os_version
      t.string :browser_version
      t.string :os
      t.string :device
      t.string :browser
    end
  end
end
