Class('Item.View', {

    Extends: Component,

    initialize: function() {
        Item.View.Super.call(this, 'result');
        this.retrieveAnExhibition();
    },

    render: function(item) {
        this.element.item = item;
        this.show();
    },

    show: function() {
        this.element.visible = true;
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

    subscribe: function() {
        Bus.subscribe('item.saved', this.render.bind(this));
        Bus.subscribe('exhibition.retrieved', this.renderExhibition.bind(this));
    }

});
