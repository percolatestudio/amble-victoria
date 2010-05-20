(function($){
  placesShow = {
    onReady: function() {
      $('#content').place_cards({
        success: function(place, link) { 
          if (link.hasClass('save')) {
            place.addClass('saved');
          } else {
            place.removeClass('saved');
          }
        }
      });      
    }
  }
}(jQuery));