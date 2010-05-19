(function($){
  usersMyPlaces = {
    onReady: function() {
      $('.place').place({
        success: function(place) { 
          place.detach();
        }
      });      
      
      $('.lang').click(function() {
        // TODO: effects
        $('#logged_in_description').show();
        $('#logout').hide();        
      });
      
      $('#logged_in_description a').click(function() {
        // TODO: effects
        $('#logged_in_description').hide();
        $('#logout').show();
      });
    }
  }
}(jQuery));