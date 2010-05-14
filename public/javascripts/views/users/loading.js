(function($){
  usersLoading = {
    onReady: function() {
      // // remove the loading div
      // $('#static').remove();
      // 
      // // make sure all links target the content pane
      $('a:not(.fbconnect_login_button):not(.noTargetContent)').targetContent('#content');
      $('form:not(.noTargetContent)').formTargetContent('#content');
      
      $.loadContent('#content', '/places/');
    }
  }
}(jQuery));