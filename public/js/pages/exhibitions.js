Class('Page.Exhibitions', {

    initialize: function() {
        new Services.Exhibitions();
        new Exhibitions.List();
        new Exhibitions.Form();
        new Exhibitions.Panel();
        this.retrieveExhibitions();
    },

    retrieveExhibitions: function() {
        Bus.publish('exhibitions.list.retrieve');
    }

});
