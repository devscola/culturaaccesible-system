Class('Info.Form', {

    Extends: Component,

    initialize: function() {
        Info.Form.Super.call(this, 'info-form');
        this.field = document.getElementById('info-field');
        this.textarea = document.getElementById('info-textarea');
    },

    subscribe: function() {
    }

});

