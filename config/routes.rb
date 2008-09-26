ActionController::Routing::Routes.draw do |map|
  map.resources :locations
  map.all 'all', :controller => 'locations', :all => true

  map.root :locations
end
