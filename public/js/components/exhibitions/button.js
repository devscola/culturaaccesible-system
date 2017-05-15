Class('Exhibitions.AddButton', {

    Extends: Component,

    initialize: function() {
        Exhibitions.AddButton.Super.call(this, 'action');
        this.element.addEventListener('started', this.createExhibition.bind(this));
    },

    createExhibition: function() {
        Bus.publish('exhibition.create');
    }

});
