var Map = {
  markers: {},
  
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
    
      Map.clusterer = new Clusterer(Map.map);
      var clusterIcon = new GIcon();
      clusterIcon.image = '/images/cluster.png';
      clusterIcon.shadow = '/images/cluster-shadow.png';
      clusterIcon.iconSize = new GSize(28, 28);
      clusterIcon.shadowSize = new GSize(40, 28);
      clusterIcon.iconAnchor = new GPoint(13, 34);
      clusterIcon.infoWindowAnchor = new GPoint(13, 3);
      clusterIcon.infoShadowAnchor = new GPoint(27, 37);
      Map.clusterer.SetIcon(clusterIcon);
      Map.clusterer.SetMinMarkersPerCluster(25)
      Map.refreshMarkers();
      Event.observe(window, "unload", GUnload);
    }
  },
  
  refreshMarkers: function() {
    var bounds = Map.map.getBounds();
    
    new Ajax.Request('/locations.json', {method: 'get', 
      parameters: {callback: 'Map.callback', 
        northeast: bounds.getNorthEast().toUrlValue(),
        southwest: bounds.getSouthWest().toUrlValue()},
      onFailure: Map.ajaxError} );
  },
	 
  callback: function(data) {
    if(!Map.errors(data)) {
      if(data.locations) data.locations.each(Map.mapLocation);
      if(data.location)     Map.mapLocationAndFocus(data);
    }
  },
  
  mapLocation: function(data) {
    if (!Map.markers[data.location.id]) {
      var point = new GLatLng(data.location.geocoding.geocode.latitude, data.location.geocoding.geocode.longitude);
      Map.markers[data.location.id] = new GMarker(point, {icon:Map.icon(data.location.signs)});
      Map.markers[data.location.id].html = '<span class="'+data.location.signs.toLowerCase()+'">'+data.location.street+'</span>'+data.location.city+', '+data.location.state+' '+data.location.zip+'<br>Reported '+Date.parseISO8601(data.location.created_at).strftime('%B %d, %i:%M %p')+'<br><a href="/locations/'+data.location.id+'/edit">Edit</a> | <a href="/locations/'+data.location.id+'" class="destroy">Remove</a>';
      Map.clusterer.AddMarker(Map.markers[data.location.id], data.location.street+', '+data.location.city+', '+data.location.state)
      return point;
    }
  },

  mapLocationAndFocus: function(data) {
    Map.map.setCenter(Map.mapLocation(data), 14);
    $('map').scrollTo();
    Map.showOverlay.delay(0.5, data.location);
  },

  showOverlay: function(location) {
    Map.markers[location.id].openInfoWindowHtml(Map.markers[location.id].html);
  },
  
  findLocation: function(location_path) {
    var id = location_path.match(/\d+$/)[0];
    if (Map.markers[id]) {
      Map.showOverlay({id: id});
      $('map').scrollTo();      
    } else {
      new Ajax.Request(location_path+'.json', {method: 'get', 
        parameters: {callback: 'Map.callback'},
        onFailure: Map.ajaxError} );
    }
  },
  
  errors: function(data) {
    $$('form fieldset.address ol li.error').invoke('remove');
    if (data.errors) {
      var list = $$('form fieldset.address ol').first();
      data.errors.each(function(error) {
        var message = '';
        if (error[0] != 'base') {
          message = message + error[0] + ' ';
        }
        list.insert({top: '<li class="error">'+message.capitalize()+error[1]+'</li>'});
      });
    }
    return data.errors && !data.errors.empty();
  },
  
  ajaxError: function() {
    Map.errors({errors: [['base', "Sorry, there has been an unexpected error. He have been notified and will look into it. Please contact us if you'd like to know what we discover."]]});
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

// Dunno why IE doesn't like dom:loaded.
if (Prototype.Browser.IE) {
  Event.observe(window, "load", Map.show);
} else {
  Event.observe(window, "dom:loaded", Map.show);
}
