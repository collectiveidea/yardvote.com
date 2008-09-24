var map;

function showMap() {
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

function mapLocations(locations) {
  Event.observe(window, "dom:loaded", function() {
    locations.each(mapLocation);
  });
}

function mapLocation(l) {
  var point = new GLatLng(l.location.geocoding.geocode.latitude, l.location.geocoding.geocode.longitude);
  map.addOverlay(new GMarker(point, {icon:markers[l.location.signs]}));
  return point;
}

function mapLocationAndFocus(location) {
  map.setCenter(mapLocation(location), 14);
  $('map').scrollTo();
}

Event.observe(window, "dom:loaded", showMap);
Event.observe(window, "unload", GUnload);
