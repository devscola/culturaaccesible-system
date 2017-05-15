Class('Exhibitions.Panel', {

    Extends: Component,

    initialize: function() {
        Exhibitions.Panel.Super.call(this, 'result');
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
