Event.addBehavior({
  'form.new_location:submit': function(event) {
    event.stop();
    this.request({
      onSuccess: function() { this.reset(); }.bind(this)
    });
  }
  
});