(function($){
  layoutsApplication = {
    onReady: function() {
      // console.log('creating pkwindow');
      // this.pkwindow = new PKNavigationView();
      // this.pkwindow.size = new PKSize(window.innerWidth, window.innerHeight - 44);
      // this.pkwindow.delegate = this;
      // this.pkwindow.zIndex = 1;
      // this.pkwindow.autoresizingMask = PKViewAutoresizingFlexibleWidth;
      // this.pkwindow.id = 'nav';
      // PKRootView.sharedRoot.addSubview(this.pkwindow);
      // 
      // 
      // console.log('creating nav');
      // this.nav = new PKContentView($('ol').get(0));
      // this.nav.position = new PKPoint(0, window.innerHeight - 44);
      // this.pkwindow.pushNavigationItem(new PKNavigationItem('text', this.nav), true);
      // 
      console.log('creating scroll');
      this.scroll = new PKScrollView();
      this.scroll.horizontalScrollEnabled = false;
      this.scroll.scrollIndicatorsColor = '#333';
      this.scroll.delegate = this;      
      this.scroll.size = new PKSize(window.innerWidth, window.innerHeight - 44)
      // this.pkwindow.addSubview(this.scroll);      
      
      console.log('creating div');
      this.content = new PKContentView($('div').get(0));
      this.content.autoresizingMask = PKViewAutoresizingFlexibleWidth | PKViewAutoresizingFlexibleHeight;
      // this.content.size = new PKSize(window.innerWidth, window.innerHeight * 2)
      this.scroll.addSubview(this.content);
      PKRootView.sharedRoot.addSubview(this.scroll);
            
      // do some stuff
      var $content = $(this.content.layer);
      // content.css('backgroundColor', 'blue');
      var that = this;
      $content.load('places/', function() {
        console.log(that.content.size.height);
        console.log(that.content.layer.scrollHeight);
        that.content.size = new PKSize(window.innerWidth, that.content.layer.scrollHeight);
        console.log(that.content.size.height);
        // console.log(that.content.size);
        // that.content.refreshSize();
        // console.log(that.content.size);
      });
      
      
      // var $nav = $(this.nav.layer);
      // $nav.load('nav/')
    }
  }
}(jQuery));