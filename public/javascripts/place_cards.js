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
      event.preventDefault();
      var $p = $(this).parents('.place');
      
      $.show_details($p);
    });

    $('.place .back_btn').live('click', function(event) {
      event.preventDefault();
      
      $.hide_details();
    });
    
    $('.place_detail .actions .like').live('click', function(event) {
      event.preventDefault();
      
      $('#like_overlay')
        .find('iframe').attr('src', $(this).safe_href())
      .end().vertical_center().show();
    });
    
    $('body').click(function() { $('#like_overlay').hide(); });
  };
  
  $.show_details = function($p) {
    // 1. copy, 2. position
    $('#slide_container')
      .append($('#nav').clone())
      .append($p.clone().data('original', $p))
      .css('top', $(window).scrollTop());

    if ($('body').hasClass('l_application')) {
      $('body').addClass('slide');
    } else {
      // 3. slide
      $('body').bind('webkitTransitionEnd', function() {
        // 4. hide
        $('body > *:not(.no_slide_left)').addClass('height_hidden');

        // 5. position
        $('#slide_container')
          .css('position', 'static').get(0).scrollIntoView(true);

        $('body').unbind('webkitTransitionEnd');
      }).addClass('slide');      
    }
  };
  
  $.hide_details = function() {
    if ($('body').hasClass('l_application')) {
      $('body').removeClass('slide');
      $('#slide_container > *').detach();
    } else {
      // 1. position
      $('#slide_container')
        .css('position', 'absolute')
        .get(0).scrollIntoView(true);

      // 2. show everything
      $('body > *:not(.no_slide_left)').removeClass('height_hidden');

      // 3. slide
      $('body').bind('webkitTransitionEnd', function() {

        // 4. delete
        $('#slide_container > *').detach();

        $('body').unbind('webkitTransitionEnd');
      }).removeClass('slide');      
    }
  };
}(jQuery));