Class('Exhibition.Info', {

    Extends: Component,

    initialize: function() {
        Exhibition.Info.Super.call(this, 'info');
        this.loadExhibition();
        this.element.addEventListener('edit', this.goToEditForm.bind(this));
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
      return this.loadShortUrlData(3);
    },

    goToEditForm: function() {
      var exhibitionId = this.loadShortUrlData(3);
      window.location = '/exhibition/' + exhibitionId + '/edit';
    },

    loadShortUrlData: function(index) {
        var urlString = window.location.href;
        var regexp = /\/(exhibition)(\/)(.*)(\/)(exhibition)(\/)(.*)(|\/)(|.*)/;
        var data = regexp.exec(urlString)[index];
        return data;
    },

    subscribe: function() {
        Bus.subscribe('exhibition.retrieved', this.render.bind(this));
    }

});
