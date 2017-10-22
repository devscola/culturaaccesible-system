Class('Page.Login', {

    STATIC: {
        HOME: '/home'
    },

    initialize: function() {
        new Login.Form();
        new Services.Login();
        this.subscribe();
    },

    goToHome: function() {
        window.location = Page.Login.HOME;
    },

    subscribe: function() {
        Bus.subscribe('login.attempt.succeeded', this.goToHome);
    }
});
