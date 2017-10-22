Class('Services.Login', {

    Extends: Service,

    initialize: function() {
        Services.Login.Super.call(this, '/api');
    },

    hasSucceeded: function(result) {
        if (result.valid) {
            Bus.publish('login.attempt.succeeded', result);
        }
    },

    login: function(credentials) {
        this.doRequest('/login', credentials, this.hasSucceeded);
    },

    subscribe: function() {
        Bus.subscribe('login.attempt', this.login.bind(this));
    }

});
