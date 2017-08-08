Class('Page.RoomInfo', {

    initialize: function() {
        new Services.Exhibitions();
        new Services.Items();
        new Exhibitions.List();
        new Room.Info();
    }

});
