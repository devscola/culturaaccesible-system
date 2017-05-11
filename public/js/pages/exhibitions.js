Class('Page.Exhibitions', {

    initialize: function() {
        new Services.Exhibitions();
        new Exhibitions.AddButton();
        new Exhibitions.List();
        new Exhibitions.Form();
        new Exhibitions.Panel();
        this.publish();
    },

    publish: function() {
        Bus.publish('exhibitions.list.retrieve');
    }

});
