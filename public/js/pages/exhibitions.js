Class('Page.Exhibitions', {

    initialize: function() {
        new Services.Exhibitions();
        new Exhibitions.Panel();
        new NewExhibition.Form();
        new Exhibitions.List();
        new Exhibitions.Form();
        this.publish();
    },

    publish: function() {
        Bus.publish('exhibitions.list.retrieve');
    }

});
