Class('Page.Info', {
    initialize: function() {
        this.publish();
        new Info.Form()
    },

    publish: function() {
        console.log('page instanciated')
    }
});
