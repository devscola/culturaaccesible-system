Class('Exhibitions.Form', {

    initialize: function() {
        this.element = document.getElementById('form');
        this.element.addEventListener('exhibitionSave', this.saveExhibition.bind(this));
        this.subscribe();
    },

    showForm: function() {
        this.element.visible = true;
    },

    saveExhibition: function(exhibition) {
        Bus.publish('exhibition.save', exhibition);
    },

    subscribe: function() {
        Bus.subscribe('exhibition.new', this.showForm.bind(this));
    }

});
