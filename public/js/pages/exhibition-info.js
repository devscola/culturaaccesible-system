Class('Page.ExhibitionInfo', {

    initialize: function() {
        new Services.Exhibitions();
        new Exhibition.Info();
    }

});
