(function($){
  placesShow = {
    onReady: function() {
      $('.place').place({
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