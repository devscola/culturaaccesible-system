Class('Exhibitions.Panel', {

    initialize: function() {
        this.element = document.getElementById('panel');
        this.subscribe();
    },

    render: function(exhibition) {
        var exhibitions = [];
        exhibitions.push(exhibition);
        this.element.exhibition = exhibitions;
        this.showPanel();
    },

    showPanel: function() {
        this.element.visible = true;
    },

    subscribe: function() {
        Bus.subscribe('exhibition.saved', this.render.bind(this));
    }

});
