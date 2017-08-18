Class('Exhibition.Info', {

    Extends: Component,

    initialize: function() {
        Exhibition.Info.Super.call(this, 'info');
        this.loadExhibition();
        this.alert = document.getElementById('alert');
        this.element.addEventListener('edit', this.goToEditForm.bind(this));
        this.element.addEventListener('delete', this.showDeleteAlert.bind(this));
        this.element.addEventListener('delete.confirmation', this.delete.bind(this));
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

    delete: function(event) {
        var exhibition = event.detail
        var payload = { 'id': exhibition.id }
        Bus.publish('exhibition.delete', payload)
    },

    showDeleteAlert: function() {
      this.alert.visibility = 'show'
    },

    loadShortUrlData: function(index) {
        var urlString = window.location.href;
        var regexp = /\/(exhibition)(\/)(.*)(\/)(exhibition)(\/)(.*)(|\/)(|.*)/;
        var data = regexp.exec(urlString)[index];
        return data;
    },

    goToHome: function() {
        window.location = '/'
    },

    subscribe: function() {
        Bus.subscribe('exhibition.retrieved', this.render.bind(this));
        Bus.subscribe('exhibition.deleted', this.goToHome.bind(this));
    }

});
