Class('Exhibitions.AddButton', {

    initialize: function() {
        this.element = document.getElementById('action');
        this.element.addEventListener('publishClicked', this.createExhibition.bind(this));
    },

    createExhibition: function() {
        Bus.publish('exhibition.create');
    }

});
