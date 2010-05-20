(function($) {
  // hookup savers
  // we need options.success(place, link) to be set
  $.fn.place_cards = function(options) {
    return this.each(function() {
      var $places = $(this);
      
      $places.find('.save, .unsave').live('click', function(event) {
        event.preventDefault();
        var $this = $(this), $p = $this.parents('.place');

        if (!$p.hasClass('loading')) {
          $p.addClass('loading');
          $.ajax({
            url: $this.safe_href(),
            success: function() {options.success($p, $this)},
            complete: function() { $p.removeClass('loading'); },
            error: function(request) {
              if (request.status == 401) { // redirect to new session
                document.location = request.responseText;
              }
            }
          });
        }
      });
    });
  };
}(jQuery));