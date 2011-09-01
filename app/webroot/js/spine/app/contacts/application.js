jQuery(function($){
  
  window.App = Spine.Controller.create({
    el: $("body"),
    
    elements: {
      "#sidebar"  : "sidebarEl",
      "#contacts" : "contactsEl",
      "#details"  : "detailsEl",
      "#info"     : "infoEl"
    },
    
    init: function(){
      this.sidebar = Sidebar.init({
        el: this.sidebarEl
      });
      this.contacts = Contacts.init({
        el: this.contactsEl
      });
      this.details = Details.init({
        el: this.detailsEl
      });
      this.info = Info.init({
        el: this.infoEl
      });
      
      this.manager = new Spine.Manager(this.info, this.details);
      
      Contact.fetch();
    }
  }).init();
  
});