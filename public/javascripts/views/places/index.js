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
    }
  }
}(jQuery));