(function($){
  usersGetLocation = {
    onGetLocationCompleteCalled: false,
    
    onReady: function() {
      // make sure that spinner is going
      $('#loader').addClass('loading').vertical_center();
    },
    
    onLoad: function() {      
      //geolocation.find call is async
      $.geolocation.find(function(loc) {
        usersGetLocation.onGetLocationComplete({location: {latitude: loc.latitude, longitude: loc.longitude}});
      }, function(){
        usersGetLocation.onGetLocationComplete({});
      });      
    },
    
    onGetLocationComplete: function(request_data) {
      //work around a bug in Firefox 3.5 where the geolocaiton callback 
      //sometimes gets called multiple times
      if (usersGetLocation.onGetLocationCompleteCalled == true) {
        return;
      }
      
      //update user location, and load places
      window.location.href = '/users/update_location' + $.param(request_data);

      usersGetLocation.onGetLocationCompleteCalled = true;     
    }
  }
}(jQuery));