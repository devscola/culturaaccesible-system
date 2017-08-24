Class('Page.Museum', {

    initialize: function() {
        new Services.Museums();
        new Museum.Form();
        new Museum.View();
    }

});
