class BrowsersController < ApplicationController
  def index
    @browsers = Browser.all.order(id: :asc)
  end
end
