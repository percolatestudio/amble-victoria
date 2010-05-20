(function($){
  layoutsMobile = {
    onReady: function() {
      $('.place .show_details').live('click', function() {
        event.preventDefault();
        var $p = $(this).parents('.place');
        
        // 1. copy, 2. position
        $('#slide_container')
          .append($('#nav').clone())
          .append($p.clone())
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
        
      });

      $('#slide_container .back_btn').live('click', function() {
        event.preventDefault();
        
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
      });
      
      // scroll the location bar out view
      setTimeout(function() {
        window.scrollTo(0,1);
        window.scrollTo(0,0);
      }, 100);
    }
  }
}(jQuery));