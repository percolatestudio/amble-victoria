(function($){
  usersMyPlaces = {
    onReady: function() {
      $.has_place_cards({
        success: function(place) {
          if (place.parents('#slide_container').length) {
            place.data('original').detach();
            $.hide_details();
          } else {
            place.detach();            
          }
        }
      });      
      
      $('#logged_in_description').click(function() {
        $('#content').addClass('expanded');
      });
      
      $('#logout').click(function() {
        $('#content').removeClass('expanded');
      });      
    }
  }
}(jQuery));