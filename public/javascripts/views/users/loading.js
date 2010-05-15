(function($){
  usersLoading = {
    onReady: function() {
      // make sure all links target the content pane      
      $('a:not(.fbconnect_login_button):not(.noTargetContent)').targetContent('#content');
      $('form:not(.noTargetContent)').formTargetContent('#content');
    },
    
    onLoad: function() {      
      //geolocation.find call is async
      $.geolocation.find(function(loc) {
        usersLoading.onGetLocationComplete({location: {latitude: loc.latitude, longitude: loc.longitude}});
      }, function(){
        usersLoading.onGetLocationComplete({});
      });      
    },
    
    onGetLocationComplete: function(request_data) {
      //update user location, and load places
      jQuery.ajax({
        url: '/users/update_location',
        data: request_data,
        success: function() {  
          $.loadContent('#content', '/places/');
        },
        error: function() {  alert("error setting your location") }
      });      
    }
  }
}(jQuery));