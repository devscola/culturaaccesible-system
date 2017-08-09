Class('Exhibitions.Form', {

    Extends: Component,

    initialize: function() {
        Exhibitions.Form.Super.call(this, 'exhibition-form');
        this.exhibitionForm = document.getElementById('formulary');
        this.exhibitionButton = document.getElementById('action');

        this.exhibitionForm.addEventListener('submitted', this.save.bind(this));
        this.exhibitionButton.addEventListener('started', this.show.bind(this));
        this.element.addEventListener('validate', this.validateLink.bind(this));
    },

    show: function(event) {
        this.exhibitionForm.exhibition = event.detail;
        this.exhibitionForm.visible = true;
    },

    hide: function() {
        this.exhibitionForm.visible = false;
    },

    save: function(exhibition) {
        Bus.publish('exhibition.save', exhibition.detail);
        this.hide();
    },

    validateLink: function(media) {
        Bus.publish('link.validate', media.detail);
    },

    setValidation: function(valid){
        this.exhibitionForm.validMedia = valid;
    },

    subscribe: function() {
        Bus.subscribe('exhibition.edit', this.show.bind(this));
        Bus.subscribe('link.validation', this.setValidation.bind(this));

    }

});
