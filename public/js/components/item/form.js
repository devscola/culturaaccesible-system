Class('Item.Form', {

    Extends: Component,

    initialize: function() {
        Item.Form.Super.call(this, 'formulary');
        this.element.addEventListener('submitted', this.save.bind(this));
        this.retrieveAnExhibition();
    },

    retrieveAnExhibition: function() {
        var exhibitionId = this.loadExhibitionId();
        var payload = { 'id': exhibitionId };
        Bus.publish('exhibition.retrieve', payload);
    },

    loadExhibitionId: function() {
        return window.location.href.split('/item/')[1];
    },
    
    renderExhibition: function(exhibition) {
        this.element.exhibition = exhibition;
    },

    save: function(item) {
        Bus.publish('item.save', item.detail);
    },

    subscribe: function() {
        Bus.subscribe('exhibition.retrieved', this.renderExhibition.bind(this));
    }
});
