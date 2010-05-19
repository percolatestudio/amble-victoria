(function($){
  placesIndex = {
    onReady: function() {
      $('.place .savers a').live('click', function(event) {
        event.preventDefault();
        var $p = $(this).parents('.place'), $this = $(this);
        
        if (!$p.hasClass('loading')) {
          $p.addClass('loading');
          $.ajax({
            url: $this.safe_href(),
            success: function() { 
              if ($this.hasClass('save')) {
                $p.addClass('saved');
              } else {
                $p.removeClass('saved');
              }
            },
            complete: function() { $p.removeClass('loading'); },
            error: function(request) {
              if (request.status == 401) { // redirect to new session
                document.location = request.responseText;
              }
            }
          });
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
        geolocation.set();
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
    }
  }
}(jQuery));