ActionController::Routing::Routes.draw do |map|
  map.resources :locations, :cities, :audits
  map.all 'all', :controller => 'locations', :all => true

  map.root :locations
end
