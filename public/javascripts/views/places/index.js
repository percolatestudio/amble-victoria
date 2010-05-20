(function($){
  placesIndex = {
    onReady: function() {
      $.has_place_cards({
        success: function(place, link) { 
          if (link.hasClass('save')) {
            if (place.parents('#slide_container').length) {
              place.data('original').addClass('saved');
            }
            place.addClass('saved');
          } else {  
            if (place.parents('#slide_container').length) {
              place.data('original').removeClass('saved');
            }
            place.removeClass('saved');
          }
        }
      });
      
      
      $('#place_filter_category_id').change(function() {
        $('#place_filter').submit();
      });

      $('#place_filter').submit(function() {
        var form = this;

        $.ajax({
          cache: false,
          data: $.param($(form).serializeArray()),          
          type: form.method,
          url: form.action,

          success: function(data,txtStatus,xmlHttpReq) {
            $('#content').replaceWith( data )
          },

          error: function(xmlHttpReq) {
            var errMsg = xmlHttpReq.responseText
            
            if ((typeof(errMsg) != "undefined") && (errMsg.length != 0)) {
              alert(errMsg)
            } else {
              alert("An error occured")
            }
          }
        });

        return false;
      });


      $('.locate_btn').click(function() {
        geolocation.set(true, function() { 
          $('#place_filter_location').val('')          
          $('#place_filter').submit();
        });
        
        return false;
      });
      
      // pagination
      $('.more_places a').live('click', function(event) {
        event.preventDefault();
        $.get($(this).safe_href(), function(data) {
          $('.more_places').replaceWith(data);
        })
      });
      
      // nav_bar animation
      $('#current_location').live('click', function(event) {
        event.preventDefault();
        $('body').addClass('expanded');
      });
      
      $('.uang').live('click', function() {
        $('body').removeClass('expanded');
      });
    }
  }
}(jQuery));