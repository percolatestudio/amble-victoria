(function($){
  usersGetLocation = {
    onGetLocationCompleteCalled: false,
    
    onReady: function() {
      // make sure that spinner is going
      $('#loader').addClass('loading').vertical_center();
    },
    
    onLoad: function() {      
      geolocation.set();
    }
  }
}(jQuery));