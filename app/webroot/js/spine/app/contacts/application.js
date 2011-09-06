jQuery(function($){
  
  window.App = Spine.Controller.create({
    el: $("body"),
    
    elements: {
      "#sidebar"    : "sidebarEl",
      "#contacts"   : "contactsEl",
      "#album"      : "albumEl",
      "#upload"     : "uploadEl",
      "#grid"       : "gridEl",
      '.vDragabble' : 'vDrag',
      '.hDragabble' : 'hDrag'
    },
    
    init: function(){
      this.sidebar = Sidebar.init({
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
      this.vmanager.alive(this.vDrag, {
        autodim: this.proxy(function() {
          return $(this.sidebar.el).width()/2;
        }),
        disabled: false,
        axis: 'x',
        min: 50,
        max: function() {
          return 900;
        }
      });
      this.hmanager = new Spine.Manager(this.album, this.upload, this.grid);
      this.hmanager.alive(this.hDrag, {
        autodim: this.proxy(function() {
          return $(this.contacts.el).height()/2;
        }),
        axis: 'y',
        min: 50,
        max: function() {
          return 500;
        }
      });
      
      Contact.fetch();
    }
  }).init();
  
});