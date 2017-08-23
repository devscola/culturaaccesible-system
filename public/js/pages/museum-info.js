Class('Page.MuseumInfo', {

    initialize: function() {
        new Services.Exhibitions();
        new Services.Museums();
        new Exhibitions.List();
        new Museum.Info();
    }

});
