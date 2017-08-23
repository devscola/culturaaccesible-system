Class('Page.Item', {
    initialize: function() {
        new Services.Exhibitions();
        new Services.Museums();
        new Services.Items();
        new Exhibitions.List();
        new Item.Form();
        new Item.View();
    }
});
