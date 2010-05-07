(function($) {
  $(function(){
    $('.place').click(function(){
      $(this).toggleClass('flipped');
      // this.scrollIntoView(true);
    });
    
    $(window).scroll(function(){
    });
  });
}(jQuery));