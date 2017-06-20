Class('Exhibitions.Panel', {

    Extends: Component,

    initialize: function() {
        Exhibitions.Panel.Super.call(this, 'result');
        this.element.addEventListener('edit', this.hide.bind(this));
    },

    render: function(exhibition) {
        this.element.exhibition = exhibition;
        this.show();
    },

    show: function() {
        this.element.visible = true;
    },

    hide: function() {
        this.element.visible = false;
        Bus.publish('exhibition.edit');
    },

    subscribe: function() {
        Bus.subscribe('exhibition.saved', this.render.bind(this));
    }

});
