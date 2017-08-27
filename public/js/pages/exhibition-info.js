Class('Page.ExhibitionInfo', {

    initialize: function() {
        new Services.Exhibitions();
        new Services.Museums();
        new Exhibitions.List();
        new Exhibitions.Info();
    }

});
