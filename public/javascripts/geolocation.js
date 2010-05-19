var geolocation = {
  onGetLocationCompleteCalled: false,
  
  set: function() {      
    //geolocation.find call is async
    $.geolocation.find(function(loc) {
      geolocation.onGetLocationComplete({location: {latitude: loc.latitude, longitude: loc.longitude}});
    }, function(){
      geolocation.onGetLocationComplete({});
    });      
  },

  onGetLocationComplete: function(request_data) {
    //work around a bug in Firefox 3.5 where the geolocaiton callback 
    //sometimes gets called multiple times
    if (geolocation.onGetLocationCompleteCalled == true) {
      return;
    }
    
    //update user location, and load places
    window.location.href = '/users/update_location?' + $.param(request_data);

    geolocation.onGetLocationCompleteCalled = true;     
  }
};
