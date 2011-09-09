jQuery(function($){
  
  window.App = Spine.Controller.create({
    el: $("body"),
    
    elements: {
      "#sidebar"    : "sidebarEl",
      "#contacts"   : "contactsEl",
      "#album"      : "albumEl",
      "#upload"     : "uploadEl",
      "#grid"       : "gridEl",
      '.vdraggable' : 'vDrag',
      '.hdraggable' : 'hDrag'
    },
    
    init: function(){
      this.sidebar = new Sidebar({
        el: this.sidebarEl
      });
      this.contacts = Contacts.init({
        el: this.contactsEl
      });
      this.album = Album.init({
        el: this.albumEl
      });
      this.upload = Upload.init({
        el: this.uploadEl
      });
      this.grid = Grid.init({
        el: this.gridEl
      });
      
      this.vmanager = new Spine.Manager(this.sidebar);
      this.vmanager.startDrag(this.vDrag, {
        initSize: this.proxy(function() {
          return $(this.sidebar.el).width()/2;
        }),
        disabled: false,
        axis: 'x',
        min: 250,
        max: this.proxy(function() {
          return $(this.el).width()/2;
        })
      });
      this.hmanager = new Spine.Manager(this.album, this.upload, this.album, this.grid);
      this.hmanager.startDrag(this.hDrag, {
        initSize: this.proxy(function() {
          return $(this.contacts.el).height()/2;
        }),
        disabled: true,
        axis: 'y',
        min: 0,
        max: this.proxy(function() {
          return $(this.contacts.el).height()/2;
        })
      });
      
      Contact.fetch();
    }
  }).init();
  
});