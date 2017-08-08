Class('Page.SceneInfo', {

    initialize: function() {
        new Services.Exhibitions();
        new Services.Items();
        new Exhibitions.List();
        new Scene.Info();
    }

});
