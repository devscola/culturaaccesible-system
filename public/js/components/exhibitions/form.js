Class('Exhibitions.Form', {

    Extends: Component,

    initialize: function() {
        Exhibitions.Form.Super.call(this, 'exhibition-form');
        this.exhibitionForm = document.getElementById('formulary');
        this.exhibitionButton = document.getElementById('action');

        this.exhibitionForm.addEventListener('submitted', this.saveExhibition.bind(this));
        this.exhibitionButton.addEventListener('started', this.showForm.bind(this));
    },

    showForm: function() {
        this.exhibitionForm.visible = true;
    },

    saveExhibition: function(exhibition) {
        Bus.publish('exhibition.save', exhibition);
    }

});
