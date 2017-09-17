Class('Museum.View', {

    Extends: Component,

    initialize: function() {
        Museum.View.Super.call(this, 'result');
    },

    render: function(museumData) {
        this.element.museumData = museumData;
        this.element.visibility = 'show';
        this.goToInfoPanel();
        Bus.publish('museum.list.retrieve');
    },

    goToInfoPanel: function() {
        var museumId = this.loadShortUrlData(3);
        window.location = '/museum/' + museumId ;
    },

    getMuseumId: function() {
      var url = window.location.href;
      return this.loadShortUrlData(3);
    },

    loadShortUrlData: function(index) {
        var urlString = window.location.href;
        var regexp = /\/(museum)(\/)(.*)(\/)(edit)/;
        var data = regexp.exec(urlString)[index];
        return data;
    },

    subscribe: function() {
        Bus.subscribe('museum.saved', this.render.bind(this));
    }

});
