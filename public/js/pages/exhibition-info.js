Class('Page.ExhibitionInfo', {

    initialize: function() {
        new Services.Exhibitions();
        new Exhibitions.List();
        new Exhibition.Info();
    }

});
