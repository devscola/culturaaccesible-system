Class('Page.Info', {
    initialize: function() {
        this.publish();
        new Info.Form();
        new Info.View();
    },

    publish: function() {
        console.log('page instanciated');
    }
});
