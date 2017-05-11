Class('Exhibitions.AddButton', {

    initialize: function() {
        this.element = document.getElementById('new-exhibition');
        this.element.addEventListener('exhibitionCreate', this.publishClicked.bind(this));
    },

    publishClicked: function() {
        Bus.publish('exhibition.create');
    }

});
