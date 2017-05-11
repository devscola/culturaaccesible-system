Class('Exhibitions.Form', {

    initialize: function() {
        this.element = document.getElementById('formulary');
        this.element.addEventListener('submitClicked', this.saveExhibition.bind(this));
        this.subscribe();
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
