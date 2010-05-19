(function($){
  usersMyPlaces = {
    onReady: function() {
      $('.remove').click(function(event) {
        event.preventDefault();
        
        var $p = $(this).parents('.place'), $this = $(this);
        if (!$p.hasClass('loading')) {
          $p.addClass('loading');
          $.ajax({
            url: $this.safe_href(),
            success: function() { 
              $p.detach();
            },
            error: function() { $p.removeClass('loading'); }
          });
        }
      })
    }    
  }
}(jQuery));