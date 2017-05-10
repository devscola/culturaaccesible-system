Class('Exhibitions.Form', {

    initialize: function() {
        this.element = document.getElementById('form');
        this.element.addEventListener('exhibitionSave', this.saveExhibition.bind(this));
        this.subscribe();
    },

    showForm: function() {
        this.element.visible = true;
    },

    saveExhibition: function() {
        Bus.publish('exhibition.save');
    },

    subscribe: function() {
        Bus.subscribe('exhibition.new', this.showForm.bind(this));
    }

});
