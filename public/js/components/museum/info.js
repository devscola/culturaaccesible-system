Class('Museum.Info', {

    Extends: Component,

    initialize: function() {
        Museum.Info.Super.call(this, 'museum-info');
        this.newButton = document.getElementById('newMuseum');
        this.exhibitionButton = document.getElementById('action');
        this.exhibitionButton.addEventListener('started', this.goToNewExhibition.bind(this));
        this.newButton.addEventListener('createMuseum', this.goToNewMuseum.bind(this));
        this.element.addEventListener('edit', this.goToEditForm.bind(this));
        this.getMuseum();
    },

    goToNewMuseum: function() {
        window.location = '/museum';
    },

    goToNewExhibition: function() {
        window.location = '/home';
    },

    render: function(museum) {
        this.element.museumData = museum;
        this.element.visibility = 'show';
    },

    getMuseum: function() {
        var id = this.loadShortUrlData(3);
        var payload = {'id': id};
        Bus.publish('museum.retrieve', payload);
    },

    goToEditForm: function() {
        var museumId = this.loadShortUrlData(3);
        window.location = '/museum/' + museumId + '/edit';
    },

    loadShortUrlData: function(index) {
        var urlString = window.location.href;
        var regexp = /\/(museum)(\/)(.*)/;
        var data = regexp.exec(urlString)[index];
        return data;
    },

    subscribe: function() {
        Bus.subscribe('museum.retrieved', this.render.bind(this));
    }

});
