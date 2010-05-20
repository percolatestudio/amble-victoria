(function($){
  usersMyPlaces = {
    onReady: function() {
      $('.places').place_cards({
        success: function(place) { 
          place.detach();
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