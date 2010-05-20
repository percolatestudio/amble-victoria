(function($){
  layoutsMobile = {
    onReady: function() {
      // scroll the location bar out view
      setTimeout(function() {
        window.scrollTo(0,1);
        window.scrollTo(0,0);
      }, 100);
    }
  }
}(jQuery));