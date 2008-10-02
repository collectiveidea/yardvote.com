ActionController::Routing::Routes.draw do |map|
  map.resources :locations, :collection => {:removed => :get, :recover => :put}
  map.resources :cities, :audits
  map.all 'all', :controller => 'locations', :all => true

  map.root :locations
end
