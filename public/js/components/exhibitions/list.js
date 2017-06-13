Class('Exhibitions.List', {

    Extends: Component,

    initialize: function() {
        Exhibitions.List.Super.call(this, 'listing');
        this.retrieve();
    },

    render: function(exhibitions) {
        this.element.exhibitionsList = exhibitions;
    },

    refresh: function() {
        Bus.publish('exhibitions.list.retrieve');
    },

    retrieve: function() {
        Bus.publish('exhibitions.list.retrieve');
    },

    subscribe: function() {
        Bus.subscribe('exhibitions.list.retrieved', this.render.bind(this));
        Bus.subscribe('exhibition.saved', this.refresh.bind(this));
    }
});
