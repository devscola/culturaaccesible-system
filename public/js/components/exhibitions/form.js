Class('Exhibitions.Form', {

    Extends: Component,

    initialize: function() {
        Exhibitions.Form.Super.call(this, 'exhibition-form');
        this.exhibitionForm = document.getElementById('formulary');
        this.exhibitionButton = document.getElementById('action');

        this.exhibitionForm.addEventListener('submitted', this.save.bind(this));
        this.exhibitionButton.addEventListener('started', this.show.bind(this));
    },

    show: function() {
        this.exhibitionForm.visible = true;
    },

    save: function(exhibition) {
        Bus.publish('exhibition.save', exhibition.detail);
        this.exhibitionForm.visible = false;
    },

    subscribe: function() {
        Bus.subscribe('exhibition.edit', this.show.bind(this));
    }

});
