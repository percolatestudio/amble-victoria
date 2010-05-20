var geolocation = {
  //we use this to work around a bug in Firefox 3.5 where the geolocaiton 
  //callback sometimes gets called multiple times
  onGetLocationCompleteCalled: false,
  updateUrl: '/users/update_location',
  
  set: function(useAjax, callback) {      
    geolocation.onGetLocationCompleteCalled = false;
    
    useAjax = typeof(useAjax) != 'undefined' ? useAjax : false;
    callback = typeof(callback) != 'undefined' ? callback : function(){};
    
    if (useAjax == true) {
      onGetLocationComplete = geolocation.ajaxUpdateLocation;
    }
    else {
      onGetLocationComplete = geolocation.updateLocation;
    }
    
    //geolocation.find call is async
    $.geolocation.find(function(loc) {
      if (geolocation.onGetLocationCompleteCalled == false) {
        onGetLocationComplete({location: {latitude: loc.latitude, longitude: loc.longitude}}, callback);
      }
      
      geolocation.onGetLocationCompleteCalled = true;
    }, function(){
      if (geolocation.onGetLocationCompleteCalled == false) {
        onGetLocationComplete({}, callback);
      }
      
      geolocation.onGetLocationCompleteCalled = true;
    });      
  },
  
  updateLocation: function(request_data) {
    window.location.href = geolocation.updateUrl + "?" + $.param(request_data);
  },
  
  ajaxUpdateLocation: function(request_data, callback) {
    $.ajax({
      cache: false,
      data: request_data,          
      type: "POST",
      url: geolocation.updateUrl,

      success: function(data,txtStatus,xmlHttpReq) {
        callback();
      },

      error: function() {
        alert("An error occured while updating your location")
      }
    });
  }
};
