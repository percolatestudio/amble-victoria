(function($){
  usersGetLocation = {
    onGetLocationCompleteCalled: false,
    
    onReady: function() {
    },
    
    onLoad: function() {      
      geolocation.set();
    }
  }
}(jQuery));