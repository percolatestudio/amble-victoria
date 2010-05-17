(function($){
  placesQuickedit = {
    onReady: function() {      
      $(document).keypress(function(event) {
        var chr =  String.fromCharCode( event.which );
        var uq_select = jQuery('#user_quality_select').get(0);

        if ((chr >= 0) && (chr <= 10)) {
          var img_select = jQuery('#primary_image_select').get(0);

          if (chr < img_select.length) {
            img_select.selectedIndex = chr;

            jQuery('#primary_image ul img').removeClass('active');
            jQuery('#place_image' + chr).addClass('active')
          } 

          
          uq_select.selectedIndex = 2;
          jQuery('form').submit();
        }
        else if (chr == 'h') {
          uq_select.selectedIndex = 1;
          jQuery('form').submit();
        }
        else if (chr == 'e') {
          window.location.pathname = jQuery('#edit').attr('href');
        }

      });
    }
  }
}(jQuery));