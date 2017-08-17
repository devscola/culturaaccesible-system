Class('Exhibitions.Panel', {

    Extends: Component,

    initialize: function() {
        Exhibitions.Panel.Super.call(this, 'result');
        this.element.addEventListener('edit', this.hide.bind(this));
        this.element.addEventListener('delete', this.delete.bind(this));
    },

    render: function(exhibition) {
        this.element.exhibition = exhibition;
        this.show();
    },

    show: function() {
        this.element.visible = true;
    },

    hide: function(event) {
        this.element.visible = false;
        Bus.publish('exhibition.edit', event);
    },

    delete: function(event) {
        var exhibition = event.detail
        var payload = { 'id': exhibition.id }
        Bus.publish('exhibition.delete', payload)
    },

    goToHome: function() {
        window.location = '/'
    },

    subscribe: function() {
        Bus.subscribe('exhibition.saved', this.render.bind(this));
        Bus.subscribe('exhibition.deleted', this.goToHome.bind(this));
    }

});
