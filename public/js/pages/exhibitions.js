Class('Page.Exhibitions', {

    initialize: function() {
        new Services.Exhibitions();
        new Exhibitions.List();
        new Exhibitions.Form();
        new Exhibitions.Panel();
    }

});
