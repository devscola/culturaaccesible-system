Class('Exhibitions.List', {

    initialize: function() {
        this.element = document.getElementById('listing');
        this.subscribe();
    },

    render: function(exhibitions) {
        this.empty();
        this.element.exhibitionsList = exhibitions;
    },

    empty: function() {
        this.element.html = '';
    },

    subscribe: function() {
        Bus.subscribe('exhibitions.list.retrieved', this.render.bind(this));
    }
});
