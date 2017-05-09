Class('Page.Exhibitions', {
    
    initialize: function() {
        new Services.Exhibitions();
        new Exhibitions.List();
        this.publish();
    },

    publish: function() {
        Bus.publish('exhibitions.list.retrieve');
    }
});
