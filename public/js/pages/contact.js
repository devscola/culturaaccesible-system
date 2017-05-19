Class('Page.Contact', {
    initialize: function() {
        this.publish();
        new Contact.View()
        new Contact.Form()
    },

    publish: function() {
        console.log('page instanciated')
    }
});
