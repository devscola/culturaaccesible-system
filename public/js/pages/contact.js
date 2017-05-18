Class('Page.Contact', {
    initialize: function() {
        this.publish();
        new Contact.View()
    },

    publish: function() {
        console.log('page instanciated')
    }
});
