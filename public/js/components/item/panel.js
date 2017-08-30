Class('Item.View', {

    Extends: Component,

    initialize: function() {
        Item.View.Super.call(this, 'result');
        this.exhibitionButton = document.getElementById('action');
        this.exhibitionButton.addEventListener('started', this.goToNewExhibition.bind(this));
        this.element.addEventListener('edit', this.hide.bind(this));
        this.element.addEventListener('submitted', this.show.bind(this));
        this.element.addEventListener('delete', this.delete.bind(this));
        this.retrieveAnExhibition();
    },

    goToNewExhibition: function() {
        window.location = '/home';
    },

    render: function(item) {
        this.element.item = item;
        this.show();
        Bus.publish('exhibitions.list.retrieve');
    },

    delete: function(item) {
      var payload = { 'id': item.detail.id, 'exhibition_id': this.loadShortUrlData(3) };
      Bus.publish('item.delete', payload);
    },

    show: function() {
        this.element.viewVisibility = 'show';
    },

    hide: function(event) {
        this.element.viewVisibility = 'hide';
        Bus.publish('item.edit', event);
    },

    retrieveAnExhibition: function() {
        var exhibitionId = this.loadExhibitionId();
        var payload = { 'id': exhibitionId };
        Bus.publish('exhibition.retrieve', payload);
    },

    loadExhibitionId: function() {
        return window.location.href.split('/item/')[1];
    },

    loadShortUrlData: function(index) {
        var urlString = window.location.href;
        var regexp = /\/(exhibition)(\/)(.*)(\/)(exhibition|room|scene)(\/)(.*)(|\/)(|.*)/;
        var data = regexp.exec(urlString)[index];
        return data;
    },

    renderExhibition: function(exhibition) {
        this.element.exhibition = exhibition;
    },

    subscribe: function() {
        Bus.subscribe('item.saved', this.render.bind(this));
        Bus.subscribe('exhibition.retrieved', this.renderExhibition.bind(this));
        Bus.subscribe('item.deleted', this.goToNewExhibition.bind(this));
    }

});
