Class('Scene.Info', {

    Extends: Component,

    initialize: function() {
        Scene.Info.Super.call(this, 'sceneInfo');
        this.exhibitionButton = document.getElementById('action');
        this.museumButton = document.getElementById('newMuseum');

        this.museumButton.addEventListener('createMuseum', this.goToNewMuseum.bind(this));
        this.exhibitionButton.addEventListener('started', this.goToNewExhibition.bind(this));
        this.element.addEventListener('edit', this.goToEditForm.bind(this));
        this.element.addEventListener('delete', this.delete.bind(this));
        this.loadScene();
    },

    goToNewMuseum: function() {
        window.location = '/museum';
    },

    goToNewExhibition: function() {
        window.location = '/home';
    },

    render: function(scene) {
        this.element.scene = scene;
    },

    loadScene: function() {
      var id = this.getSceneId();
      var exhibitionId = this.loadShortUrlData(3);

      var payload = { 'id': id, 'exhibition_id': exhibitionId };

      Bus.publish('item.retrieve', payload);
    },

    getSceneId: function() {
      return this.loadShortUrlData(7);
    },

    goToEditForm: function() {
      var parentId = this.loadShortUrlData(7);
      var exhibitionId = this.loadShortUrlData(3);
      var parentClass = this.loadShortUrlData(5);
      window.location = '/exhibition/' + exhibitionId + '/' + parentClass + '/' + parentId + '/edit';
    },

    delete: function(item) {
      var payload = {'id': item.detail.id, 'exhibition_id': this.loadShortUrlData(3)}
      Bus.publish('item.delete', payload)
    },

    loadShortUrlData: function(index) {
        var urlString = window.location.href;
        var regexp = /\/(exhibition)(\/)(.*)(\/)(exhibition|room|scene)(\/)(.*)(|\/)(|.*)/;
        var data = regexp.exec(urlString)[index];
        return data;
    },

    subscribe: function() {
        Bus.subscribe('item.retrieved', this.render.bind(this));
        Bus.subscribe('item.deleted', this.goToNewExhibition.bind(this))
    }

});
