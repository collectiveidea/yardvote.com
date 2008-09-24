var map;

function show_map() {
  if (GBrowserIsCompatible()) {
    map = new GMap2(document.getElementById("map"));
    map.setCenter(new GLatLng(42.77309, -86.101754), 12);
    map.enableScrollWheelZoom();
    map.addControl(new GLargeMapControl());
    map.addControl(new GMapTypeControl());
    map.addControl(new GScaleControl());
    map.addControl(new GOverviewMapControl());
  }
}

function map_locations(locations) {
  Event.observe(window, "dom:loaded", function() {
    locations.each(map_location);
  });
}

function map_location(l) {
  var point = new GLatLng(l.location.geocoding.geocode.latitude, l.location.geocoding.geocode.longitude);
  map.addOverlay(new GMarker(point, {icon:markers[l.location.signs]}));
  return point;
}

function map_location_and_focus(location) {
  map.setCenter(map_location(location), 14);
  $('map').scrollTo();
}

Event.observe(window, "dom:loaded", show_map);
Event.observe(window, "unload", GUnload);
