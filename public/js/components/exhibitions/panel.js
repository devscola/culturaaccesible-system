Class('Exhibitions.Panel', {

    initialize: function() {
        this.element = document.getElementById('result');
        this.subscribe();
    },

    render: function(exhibition) {
        this.element.exhibition = exhibition;
        this.showPanel();
    },

    showPanel: function() {
        this.element.visible = true;
    },

    subscribe: function() {
        Bus.subscribe('exhibition.saved', this.render.bind(this));
    }

});
