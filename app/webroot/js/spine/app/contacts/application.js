jQuery(function($){
  
  window.App = Spine.Controller.create({
    el: $("body"),
    
    elements: {
      "#sidebar"  : "sidebarEl",
      "#contacts" : "contactsEl",
      "#album"    : "albumEl",
      "#upload"   : "uploadEl",
      "#grid"     : "gridEl"
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
      
      this.manager = new Spine.Manager(this.album, this.upload, this.grid);
      
      Contact.fetch();
    }
  }).init();
  
});