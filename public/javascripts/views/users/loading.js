(function($){
  usersLoading = {
    onReady: function() {
      if (!('amble' in window)) { window.amble = {}; }
      
      window.amble.pk = {};
      console.log('creating scroll');
      window.amble.pk.scroll = new PKScrollView();
      window.amble.pk.scroll.horizontalScrollEnabled = false;
      window.amble.pk.scroll.scrollIndicatorsColor = '#333';
      window.amble.pk.scroll.delegate = this;      
      window.amble.pk.scroll.size = new PKSize(window.innerWidth, window.innerHeight - 44)
      
      console.log('creating div');
      window.amble.pk.content = new PKContentView($('<div id="content">').get(0));
      window.amble.pk.content.autoresizingMask = PKViewAutoresizingFlexibleWidth | PKViewAutoresizingFlexibleHeight;
      window.amble.pk.scroll.addSubview(window.amble.pk.content);
      PKRootView.sharedRoot.addSubview(window.amble.pk.scroll);
      
      // remove the loading div
      $('#static').remove();
      
      $.loadContent('#content', '/places/');
    }
  }
}(jQuery));