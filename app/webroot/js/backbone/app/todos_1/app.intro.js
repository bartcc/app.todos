$(function() {
  return;
    setTimeout(function(){
        App.showhideControls('#main-box', 200);
        setTimeout(function() {
            App.showhideControls('#sync-box', 200);
            setTimeout(function() {
                App.showhideControls('#sync-box', 200);
                setTimeout(function() {
                    App.showhideControls('#client-box', 200);
                    setTimeout(function() {
                        App.showhideControls('#client-box', 200);
                        setTimeout(function() {
                            App.showhideControls('#storage-box', 200);
                            setTimeout(function() {
                                App.renderStorage();
                                setTimeout(function() {
                                    App.renderStorage();
                                    setTimeout(function() {
                                        App.showhideControls('#storage-box', 200);
                                        setTimeout(function() {
                                            App.showhideControls('#main-box', 200);
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