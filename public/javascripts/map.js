var Map = {
  markers: [],
  
  show: function() {
    var mapDiv = $('map')
    if (mapDiv && GBrowserIsCompatible()) {
      Map.map = new GMap2(document.getElementById("map"));
      Map.map.setCenter(new GLatLng(42.77309, -86.101754), 12);
      Map.map.enableScrollWheelZoom();
      Map.map.addControl(new GLargeMapControl());
      Map.map.addControl(new GMapTypeControl());
      Map.map.addControl(new GScaleControl());
      Map.map.addControl(new GOverviewMapControl());
    
      // listen for clicks
      GEvent.addListener(Map.map, 'click', function(overlay, point) {
        if (overlay) {
          // we now need a check here in case the overlay is the info window
          // only our icons will have a .html property
          if (overlay.html) {
            overlay.openInfoWindowHtml(overlay.html);
          }
        } else if (point) {
          //whatever you want to happen if you don't click on an overlay.
        }
      });
      
      GEvent.addListener(Map.map, "moveend", Map.refreshMarkers);
      GEvent.addListener(Map.map, "zoomend", Map.refreshMarkers);
    
      Map.mgr = new MarkerManager(Map.map);    
      Map.refreshMarkers();
      Event.observe(window, "unload", GUnload);
    }
  },
  
  refreshMarkers: function() {
    var bounds = Map.map.getBounds();
    new Ajax.Request('/locations.json', {method: 'get', 
      parameters: {callback: 'Map.mapLocations', 
        northeast: bounds.getNorthEast().toUrlValue(),
        southwest: bounds.getSouthWest().toUrlValue()}} );
  },
  
  mapLocations: function(locations) {
    locations.each(Map.mapLocation);
  },

  mapLocation: function(l) {
    if (!Map.markers[l.location.id]) {
      var point = new GLatLng(l.location.geocoding.geocode.latitude, l.location.geocoding.geocode.longitude);
      Map.markers[l.location.id] = new GMarker(point, {icon:Map.icon(l.location.signs)});
      Map.markers[l.location.id].html = '<span class="'+l.location.signs.toLowerCase()+'">'+l.location.street+'</span>'+l.location.city+', '+l.location.state+' '+l.location.zip+'<br>Reported at '+l.location.created_at+'<br><a href="/locations/'+l.location.id+'/edit">Edit</a> | <a href="/locations/'+l.location.id+'" class="destroy">Remove</a>';
      Map.mgr.addMarker(Map.markers[l.location.id], 0);
      return point;
    }
  },

  mapLocationAndFocus: function(location) {
    Map.map.setCenter(Map.mapLocation(location), 14);
    $('map').scrollTo();
    Map.showOverlay(location.location);
  },

  showOverlay: function(location) {
    Map.markers[location.id].openInfoWindowHtml(Map.markers[location.id].html);
  },

  icons: {},

  icon: function(color) {
    if (!Map.icons[color]) {
      Map.icons[color] = new GIcon(G_DEFAULT_ICON);
      Map.icons[color].image = 'http://labs.google.com/ridefinder/images/mm_20_' + color.toLowerCase() + '.png';
      Map.icons[color].shadow = 'http://labs.google.com/ridefinder/images/mm_20_shadow.png';
      Map.icons[color].iconSize = new GSize(12, 20);
      Map.icons[color].shadowSize = new GSize(22, 20);
      Map.icons[color].iconAnchor = new GPoint(6, 20);
      Map.icons[color].infoWindowAnchor = new GPoint(5, 1);    
    }
    return Map.icons[color];
  }
}

Event.observe(window, "dom:loaded", Map.show);
