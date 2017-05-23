Class('Component', {

    initialize: function(elementId) {
        this.element = document.getElementById(elementId);
        this.subscribe();
    },

    subscribe: function() {
        console.log(this.toString() + ' not subscribed!, implement subscribe method');
    }

});
