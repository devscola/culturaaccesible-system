Class('Page.Info', {
    initialize: function() {
        this.publish();
        new Info.Form();
        new Info.Textarea();
    },

    publish: function() {
        console.log('page instanciated')
    }
});
