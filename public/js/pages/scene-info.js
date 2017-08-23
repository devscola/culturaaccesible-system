Class('Page.SceneInfo', {

    initialize: function() {
        new Services.Exhibitions();
        new Services.Museums();
        new Services.Items();
        new Exhibitions.List();
        new Scene.Info();
    }

});
