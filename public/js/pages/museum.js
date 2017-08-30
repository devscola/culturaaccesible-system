Class('Page.Museum', {

    initialize: function() {
        new Services.Exhibitions();
        new Services.Museums();
        new Exhibitions.List();
        new Museum.Form();
        new Museum.View();
    }

});
