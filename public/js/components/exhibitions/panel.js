Class('Exhibitions.Panel', {

    initialize: function() {
        this.element = document.getElementById('panel');
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
