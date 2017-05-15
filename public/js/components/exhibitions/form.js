Class('Exhibitions.Form', {

    Extends: Component,

    initialize: function() {
        Exhibitions.Form.Super.call(this, 'formulary');
        this.element.addEventListener('submitted', this.saveExhibition.bind(this));
    },

    showForm: function() {
        this.element.visible = true;
    },

    saveExhibition: function(exhibition) {
        Bus.publish('exhibition.save', exhibition);
    },

    subscribe: function() {
        Bus.subscribe('exhibition.create', this.showForm.bind(this));
    }

});
