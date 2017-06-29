Class('Page.Item', {
    initialize: function() {
        new Services.Exhibitions();
        new Item.Form();
        new Item.View();
    }
});
