Class('Login.Form', {

    Extends: Component,

    initialize: function() {
        Login.Form.Super.call(this, 'login');
        this.element.addEventListener('submit', this.doLogin);
    },

    doLogin: function(polymerEvent) {
        Bus.publish('login.attempt', polymerEvent.detail);
    }

});
