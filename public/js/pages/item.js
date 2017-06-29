Class('Page.Item', {
    initialize: function() {
        new Services.Exhibitions();
        new Services.Items();
        new Item.Form();
        new Item.View();
    }
});
