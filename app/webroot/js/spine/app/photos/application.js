jQuery(function($){
    window.App = Spine.Controller.create({
        el: $("body"),
    
        elements: {
            "#sidebar": "sidebarEl",
            "#images": "imagesEl"
        },
    
        init: function(){
            this.sidebar = Sidebar.init({ el: this.sidebarEl });
            this.images = Images.init({ el: this.imagesEl });
      
            Image.fetch();
        }
    }).init();
});