Class('Exhibition.Info', {

    Extends: Component,

    initialize: function() {
        Exhibition.Info.Super.call(this, 'info');
        this.loadExhibition();
    },

    render: function(exhibition) {
        this.element.exhibition = exhibition;
    },

    loadExhibition: function() {
      var id = this.getExhibitionId();
      var payload = { 'id': id };
      Bus.publish('exhibition.retrieve', payload);
    },

    getExhibitionId: function() {
      var url = window.location.href;
      return url.split('/exhibition/')[1];
    },

    subscribe: function() {
        Bus.subscribe('exhibition.retrieved', this.render.bind(this));
    }

});
