(function($){
  placesIndex = {
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

          error: function() {
            alert("An error occured")
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
          

      //temporary 'effects' for css
      $('.details a').click(function() {
        $('#places .place').css('display', 'none')

        $(this).parents('.place').css('display', 'block')
        $(this).parents('.place').children('.front').css('display', 'none');
        $(this).parents('.place').children('.back').css('display', 'block');

        return false;
      });

      $('.back_btn').click(function() {
        $('#places .place').css('display', 'block')
        $('#places .place .front').css('display', 'block')

        $('#places .place .back').css('display', 'none')

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