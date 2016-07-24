require 'rails_helper'

describe 'browsers routes' do
  it 'routes to browsers#index' do
    expect(get: '/browsers').to route_to(controller: 'browsers', action: 'index')
  end
end
