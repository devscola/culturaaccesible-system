Class('Page.Item', {
    initialize: function() {
        new Services.Exhibitions();
        new Services.Items();
        new Exhibitions.List();
        new Item.Form();
        new Item.View();
    }
});
