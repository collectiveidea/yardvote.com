ActionController::Routing::Routes.draw do |map|
  map.resources :locations, :cities
  map.all 'all', :controller => 'locations', :all => true

  map.root :locations
end
