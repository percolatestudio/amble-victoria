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
      
      var $p = $(this).parents('.place'), $like = $p.find('.like_overlay');
      
      
      if (!$like.is(':hidden')) {
        $like.hide();
        return false;
      }
      
      if (typeof $like.find('iframe').attr('src') == 'undefined') {
        $like.find('iframe').attr('src', $(this).safe_href());
      }
        
      $like.show();
    });
  };

  $.show_details = function($p, event) {
    event.preventDefault();
  
    $('#slide_container > *').detach();

    $('#slide_container')
      .prepend($p.clone().data('original', $p));
      
    if (!$('body').hasClass('l_application')) {  
      // save the scroll offset
      $('body').data('scrollOffset', $(window).scrollTop());
    }
      
    $('body').addClass('slide');
  };
  
  $.hide_details = function($p, event) {
    event.preventDefault();
    $('body').removeClass('slide');
      
    // scroll us back into view
    if (!$('body').hasClass('l_application')) {  
      setTimeout(function() {
        window.scrollTo(0, $('body').data('scrollOffset'));        
      }, 10);
    }
  };
}(jQuery));