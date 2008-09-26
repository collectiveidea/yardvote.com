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

Event.addBehavior({
  'form.new_location:submit': function(event) {
    event.stop();
    this.request({
      onSuccess: function() { this.reset(); }.bind(this)
    });
  },
  
  'a.destroy:click': function(event) {
    event.stop();
    if (confirm('Do you really want to delete this?')) {
      this.submit({method: 'delete'});
    }
  },
  
  'a.show:click': function(event) {
    event.stop();
    showOverlay({id: this.href.match(/\d+$/)[0]});
    $('map').scrollTo();
  }
});