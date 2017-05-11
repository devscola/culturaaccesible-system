Class('Exhibitions.List', {

    initialize: function() {
        this.element = document.getElementById('listing');
        this.subscribe();
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
