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
    
    $('.place .show_details').live('click', function() {
      event.preventDefault();
      var $p = $(this).parents('.place');
      
      $.show_details($p);
    });

    $('.place .back_btn').live('click', function() {
      event.preventDefault();
      
      $.hide_details();
    });
    
    $('.place_detail .actions .like').live('click', function(event) {
      event.preventDefault();
      
      $(this).sibling('like_overlay')
        .find('iframe').attr('src', $(this).href_safe())
      .stop().vertical_center().show();
    });
  };
  
  $.show_details = function($p) {
    // 1. copy, 2. position
    $('#slide_container')
      .append($('#nav').clone())
      .append($p.clone().data('original', $p))
      .css('top', $(window).scrollTop());
    
    // 3. slide
    $('body').bind('webkitTransitionEnd', function() {
      // 4. hide
      $('body > *:not(#slide_container)').addClass('height_hidden');
      
      // 5. position
      $('#slide_container')
        .data('top', $('#slide_container').css('top'))
        .css('top', 0).get(0).scrollIntoView(true);
        
      $('body').unbind('webkitTransitionEnd');
    }).addClass('slide');
  };
  
  $.hide_details = function() {
    // 1. position
    $('#slide_container')
      .css('top', $('#slide_container').data('top'))
      .get(0).scrollIntoView(true);
    
    // 2. show everything
    $('body > *:not(#slide_container)').removeClass('height_hidden');
    
    // 3. slide
    $('body').bind('webkitTransitionEnd', function() {
      
      // 4. delete
      $('#slide_container > *').detach();
      
      $('body').unbind('webkitTransitionEnd');
    }).removeClass('slide');
  };
}(jQuery));