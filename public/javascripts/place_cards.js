(function($) {
  // hookup savers
  // we need options.success(place, link) to be set
  $.has_place_cards = function(options) {
    $('.place .save, .place .unsave').live('click', function(event) {
      event.preventDefault();
      var $this = $(this), $p = $this.parents('.place');

      if (!$p.hasClass('loading')) {
        $p.addClass('loading');
        $.ajax({
          url: $this.safe_href(),
          success: function() {
            options.success($p, $this)
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
    
    $('.place .show_details').live('click', function(event) {
      var $p = $(this).parents('.place');
      
      $.show_details($p, event);
    });

    $('.place .back_btn').live('click', function(event) {
      var $p = $(this).parents('.place');
      
      $.hide_details($p, event);
    });
    
    $('.place_detail .actions .like').live('click', function(event) {
      event.preventDefault();
        
      if ($('body').hasClass('l_application')) {
        if (!$('#like_overlay').is(':hidden')) {
          $('#like_overlay').hide();
          return false;
        }
      }

      $('#like_overlay').show()
        .find('iframe').attr('src', $(this).safe_href());
        
      if (!$('body').hasClass('l_application')) {
        $('#like_overlay').vertical_center().show();        
      } 
    });
    
    if (!$('body').hasClass('l_application')) {  
      $('body').click(function() { $('#like_overlay').hide(); });
    }
  };

  $.show_details = function($p, event) {
    if ($('body').hasClass('l_application')) {  
      event.preventDefault();
    
      $('#slide_container > *:not(#like_overlay)').detach();
  
      $('#slide_container')
        .prepend($p.clone().data('original', $p))
        .css('top', $(window).scrollTop());
        
      $('body').addClass('slide');
    }
  };
  
  $.hide_details = function($p, event) {
    if ($('body').hasClass('l_application')) {  
      event.preventDefault();
      $('body').removeClass('slide');
    }
  };
}(jQuery));