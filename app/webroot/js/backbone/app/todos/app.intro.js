$(function() {
  return;
  setTimeout(function(){
    Todos.showhideControls('#main-box', 200);
    setTimeout(function() {
      Todos.showhideControls('#sync-box', 200);
      setTimeout(function() {
        Todos.showhideControls('#sync-box', 200);
        setTimeout(function() {
          Todos.showhideControls('#client-box', 200);
          setTimeout(function() {
            Todos.showhideControls('#client-box', 200);
            setTimeout(function() {
              Todos.showhideControls('#storage-box', 200);
              setTimeout(function() {
                Todos.renderStorage();
                setTimeout(function() {
                  Todos.renderStorage();
                  setTimeout(function() {
                    Todos.showhideControls('#storage-box', 200);
                    setTimeout(function() {
                      Todos.showhideControls('#main-box', 200);
                    }, 500)
                  }, 1000)
                }, 2000)
              }, 500)
            }, 500)
          }, 500)
        }, 500)
      }, 500)
    }, 500)
  }, 500);
})