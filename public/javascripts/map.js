var map;
var overlays = [];

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
    
    // listen for clicks
    GEvent.addListener(map, 'click', function(overlay, point) {
      if (overlay) {
        // we now need a check here in case the overlay is the info window
        // only our markers will have a .html property
        if (overlay.html) {
          overlay.openInfoWindowHtml(overlay.html);
        }
      } else if (point) {
        //whatever you want to happen if you don't click on an overlay.
      }
    });
    
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
  overlays[l.location.id] = new GMarker(point, {icon:marker(l.location.signs)});
  overlays[l.location.id].html = '<span class="'+l.location.signs.toLowerCase()+'">'+l.location.street+'</span>'+l.location.city+', '+l.location.state+' '+l.location.zip+'<br>Reported at '+l.location.created_at+'<br><a href="/locations/'+l.location.id+'/edit">Edit</a> | <a href="/locations/'+l.location.id+'" class="destroy">Remove</a>';
  map.addOverlay(overlays[l.location.id]);
  return point;
}

function mapLocationAndFocus(location) {
  map.setCenter(mapLocation(location), 14);
  $('map').scrollTo();
  showOverlay(location.location);
}

function showOverlay(location) {
  overlays[location.id].openInfoWindowHtml(overlays[location.id].html);
}

var markers = {};

function marker(color) {
  if (!markers[color]) {
    markers[color] = new GIcon(G_DEFAULT_ICON);
    markers[color].image = '/images/markers/' + color.toLowerCase() + '.png';
    markers[color].shadow = 'http://labs.google.com/ridefinder/images/mm_20_shadow.png';
    markers[color].iconSize = new GSize(12, 20);
    markers[color].shadowSize = new GSize(22, 20);
    markers[color].iconAnchor = new GPoint(6, 20);
    markers[color].infoWindowAnchor = new GPoint(5, 1);    
  }
  return markers[color];
}

Event.observe(window, "dom:loaded", showMap);
