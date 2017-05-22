Class('Page.Info', {
    initialize: function() {
        this.publish();
        new Info.Form();
        new Info.Textarea();
        new Info.Field();
    },

    publish: function() {
        console.log('page instanciated')
    }
});
