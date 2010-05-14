(function($){
  placesQuickedit = {
    onReady: function() {      
      $(document).keypress(function(event) {
        var chr =  String.fromCharCode( event.which );

        if ((chr >= 0) && (chr <= 10)) {
          var img_select = jQuery('#primary_image_select').get(0);

          if (chr < img_select.length) {
            img_select.selectedIndex = chr;

            jQuery('#primary_image ul img').removeClass('active');
            jQuery('#place_image' + chr).addClass('active')
          } 
        }
        else if (chr == 'h') {
          var uq_select = jQuery('#user_quality_select').get(0);
          uq_select.selectedIndex = 1;
        }
        else if (chr == 's') {
          jQuery('form').submit();
        }
        else if (chr == 'e') {
          window.location.pathname = jQuery('#edit').attr('href');
        }

      });
    }
  }
}(jQuery));