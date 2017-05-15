Class('Exhibitions.List', {

    Extends: Component,

    initialize: function() {
        Exhibitions.List.Super.call(this, 'listing');
    },

    render: function(exhibitions) {
        this.empty();
        this.element.exhibitionsList = exhibitions;
    },

    refresh: function() {
        Bus.publish('exhibitions.list.retrieve');
    },

    empty: function() {
        this.element.html = '';
    },

    subscribe: function() {
        Bus.subscribe('exhibitions.list.retrieved', this.render.bind(this));
        Bus.subscribe('exhibition.saved', this.refresh.bind(this));
    }
});
