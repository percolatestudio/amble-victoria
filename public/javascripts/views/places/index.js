(function($){
  placesIndex = {
    onReady: function() {
      // copied from places.js :
      $('.place').click(function(){
        $(this).toggleClass('flipped');
        // this.scrollIntoView(true);
      });

      $(window).scroll(function(){
      });      
    }
  }
}(jQuery));