jQuery(function($){
  
  window.Main = Spine.Controller.create({
    
    events: {
      'sortupdate .items'                             :'sortupdate'
    },
    
    elements: {
      ".items"                  :"items"
    },
        
    init: function(){
      
    },
    
    sortupdate: function(e, ui) {
      var task;
      this.items.children('li').each(function(index) {
        task = Task.find($(this).attr('id').replace("todo-", ""));
        if(task && task.order != index) {
          task.order = index;
          task.save();
        }
      });
    },

    render: function(){
      
    },
    
    toggle: function(){
      
    },
        
    destroy: function(){
      
    },
    
    edit: function(){
      
    },
        
    blurOnEnter: function(e) {
      
    },
        
    close: function(){
      
    },
        
    remove: function(){
      
    }
  });
    
  
});