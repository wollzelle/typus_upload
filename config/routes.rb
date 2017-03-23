Rails.application.routes.draw do

  routes_block = lambda do

    Typus.models.map(&:to_resource).each do |_resource|
      post "#{_resource}/preflight(.:format)", controller: _resource, action: 'preflight'
    end

  end

  if Typus.subdomain
    constraints :subdomain => Typus.subdomain do
      namespace :admin, path: '', &routes_block
    end
  else
    scope 'admin', {module: :admin, as: 'admin'}, &routes_block
  end

end
