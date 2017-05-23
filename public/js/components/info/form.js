Class('Info.Form', {

    Extends: Component,

    initialize: function() {
        Info.Form.Super.call(this, 'formulary');
        this.field = document.getElementById('info-field');
        this.textarea = document.getElementById('info-textarea');
        this.element.addEventListener('submitted', this.submitInfo.bind(this));
    },

    submitInfo: function(info) {
        Bus.publish('info.retrieved', info.detail);
    }

});
