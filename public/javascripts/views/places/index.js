(function($){
  placesIndex = {
    onReady: function() {
      $('.place .save a').live('click', function(event) {
        event.preventDefault();
        var $p = $(this).parents('.place'), $this = $(this);
        
        if (!$p.hasClass('loading')) {
          $p.addClass('loading');
          $.ajax({
            url: $this.safe_href(),
            success: function() { 
              if ($this.attr('id') == 'save') {
                $p.addClass('saved');
              } else {
                $p.removeClass('saved');
              }
            },
            complete: function() { $p.removeClass('loading'); }
          });
        }
      });
    }
  }
}(jQuery));