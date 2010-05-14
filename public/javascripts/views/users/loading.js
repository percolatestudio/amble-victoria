(function($){
  usersLoading = {
    onReady: function() {
      // // remove the loading div
      // $('#static').remove();
      // 
      // // make sure all links target the content pane
      $('a:not(.noTargetContent)').targetContent('#content');
      
      $.loadContent('#content', '/places/');
    }
  }
}(jQuery));