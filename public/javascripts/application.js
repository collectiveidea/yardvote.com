var Application = {
  authenticityToken: function() {
    return $('authenticity-token').content;
  }
}

var Anchor = Anchor || new Object();
Anchor.Methods = {
  // Convert the anchor link into a form submission
  submit: function(anchor) {
    var options = Object.extend({
      'method': 'post',
      'parameters': {}
    }, arguments[1] || {});
    if (Object.isString(options.parameters))
      options.parameters = options.parameters.toQueryParams();
    else if (Object.isHash(options.parameters))
      options.parameters = options.parameters.toObject();

    var params = Object.clone(options.parameters);
    params['authenticity_token'] = Application.authenticityToken();
    
    options.method = options.method.toLowerCase();
    
    if (!['get', 'post'].include(options.method)) {
      // simulate other verbs over post
      params['_method'] = options.method;
      options.method = 'post';
    }
    
    var form = new Element('form', {method: options.method, action: anchor.href});
    form.setStyle({display: 'none'});
    anchor.insert({after: form});
    $H(params).each(function(param) {
      var name = param[0], value = param[1];
      form.insert(new Element('input', {type: 'hidden', name: name, value: value}));
    });
    form.submit();
  }
}
Element.addMethods('a', Anchor.Methods);

var DefaultInputValue = Behavior.create({
  initialize: function() {
    this.onblur();
  },
  
  onfocus: function(event) {
    if(this.element.value == this.element.title) {
      this.element.removeClassName('inactive');
      this.element.value = '';
    }
  },
  
  onblur: function(event) {
    if(this.element.value == '') {
      this.element.addClassName('inactive');
      this.element.value = this.element.title;
    }
  }
});

Event.addBehavior({
  'form#new_location:submit': function(event) {
    event.stop();
    this.request({
      onLoading:  function() { this.addClassName('loading'); }.bind(this),
      onComplete: function() { this.removeClassName('loading'); }.bind(this),
      onSuccess:  function() { this.reset(); }.bind(this),
      onFailure: Map.ajaxError
    });
  },
  
  '#location_street': DefaultInputValue,
  
  'a.destroy:click': function(event) {
    event.stop();
    if (confirm('Do you really want to delete this?')) {
      this.submit({method: 'delete'});
    }
  },
  
  'a.restore:click': function(event) {
    event.stop();
    if (confirm('Do you really want to restore this?')) {
      this.submit({method: 'put'});
    }
  },
  
  'a.show:click': function(event) {
    event.stop();
    Map.findLocation(this.href);
  },

  'a.show_cities:click': function(event) {
    event.stop();
    Map.getCities(null, 'Map.mapCitiesAndZoom');
  },

	'a.show_states:click': function(event) {
		event.stop();
		var ne = "51.234407,-66.972656";
		var sw = "23.966176,-128.496094"
		
		var bounds = new GLatLngBounds(new GLatLng(23.966176,-128.496094), new GLatLng(51.234407,-66.972656));
		Map.getCities(bounds, 'Map.mapCitiesAndZoom')
	}
});

Event.addBehavior.reassignAfterAjax = true;
