var map;

function showMap() {
  var mapDiv = $('map')
  if (mapDiv && GBrowserIsCompatible()) {
    map = new GMap2(document.getElementById("map"));
    map.setCenter(new GLatLng(42.77309, -86.101754), 12);
    map.enableScrollWheelZoom();
    map.addControl(new GLargeMapControl());
    map.addControl(new GMapTypeControl());
    map.addControl(new GScaleControl());
    map.addControl(new GOverviewMapControl());
    
    Event.observe(window, "unload", GUnload);
  }
}

function mapLocations(locations) {
  Event.observe(window, "dom:loaded", function() {
    locations.each(mapLocation);
  });
}

function mapLocation(l) {
  var point = new GLatLng(l.location.geocoding.geocode.latitude, l.location.geocoding.geocode.longitude);
  map.addOverlay(new GMarker(point, {icon:marker(l.location.signs)}));
  return point;
}

function mapLocationAndFocus(location) {
  map.setCenter(mapLocation(location), 14);
  $('map').scrollTo();
}


var markers = {};

function marker(color) {
  if (!markers[color]) {
    markers[color] = new GIcon(G_DEFAULT_ICON);
    markers[color].image = 'http://labs.google.com/ridefinder/images/mm_20_' + color.toLowerCase() + '.png';
    markers[color].shadow = 'http://labs.google.com/ridefinder/images/mm_20_shadow.png';
    markers[color].iconSize = new GSize(12, 20);
    markers[color].shadowSize = new GSize(22, 20);
    markers[color].iconAnchor = new GPoint(6, 20);
    markers[color].infoWindowAnchor = new GPoint(5, 1);
  }
  return markers[color];
}

Event.observe(window, "dom:loaded", showMap);
