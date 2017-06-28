Class('Page.Museum', {

    initialize: function() {
        new Museum.Form();
        new Museum.View();
        new Services.Museums();
    }

});
