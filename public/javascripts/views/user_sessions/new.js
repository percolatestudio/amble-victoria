(function($){
  userSessionsNew = {
    onReady: function() {
      $('#login').click(function() {
        var a = $('#RES_ID_fb_login').get(0);
        
        // simulate a click event (at least in saf/ff)
        var e = document.createEvent('MouseEvents');
        e.initEvent( 'click', true, true );
        a.dispatchEvent(e);
        });
    }
  }
}(jQuery));