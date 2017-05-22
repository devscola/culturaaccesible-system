Class('Info.Form', {

    Extends: Component,

    initialize: function() {
        Info.Form.Super.call(this, 'info-form');
        this.field = document.getElementById('info-field');
        this.textarea = document.getElementById('info-textarea');
        this.element.addEventListener('submitted', this.saveInfo.bind(this));
    },

    hideForm: function() {
        this.element.visible = false;
    },

    saveInfo: function(info) {
        Bus.publish('info.retrieved', info.detail);
        this.hideForm();
    },

    subscribe: function() {
    }

});
