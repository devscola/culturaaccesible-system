Class('Exhibitions.AddButton', {

    initialize: function() {
        this.element = document.getElementById('action');
        this.element.addEventListener('started', this.createExhibition.bind(this));
    },

    createExhibition: function() {
        Bus.publish('exhibition.create');
    }

});
