Class('Museum.Info', {

    Extends: Component,

    initialize: function() {
        Museum.Info.Super.call(this, 'museum-info');
        this.getMuseum()
    },

    render: function(museum) {
        this.element.museumData = museum;
        this.element.visibility = 'show';
    },

    getMuseum: function() {
      let id = this.loadShortUrlData(3);
      let payload = {'id': id}
      Bus.publish('museum.retrieve', payload)
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
