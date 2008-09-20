ActionController::Routing::Routes.draw do |map|
  map.resources :locations

  map.root :locations
end
