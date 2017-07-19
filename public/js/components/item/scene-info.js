Class('Scene.Info', {

    Extends: Component,

    initialize: function() {
        Scene.Info.Super.call(this, 'sceneInfo');
        this.element.addEventListener('edit', this.goToEditForm.bind(this));
        this.loadScene();
    },

    render: function(scene) {
        this.element.scene = scene;
    },

    loadScene: function() {
      var id = this.getSceneId();
      var payload = { 'id': id };
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

    loadShortUrlData: function(index) {
        var urlString = window.location.href;
        var regexp = /\/(exhibition)(\/)(.*)(\/)(exhibition|room|scene)(\/)(.*)(|\/)(|.*)/;
        var data = regexp.exec(urlString)[index];
        return data;
    },

    subscribe: function() {
        Bus.subscribe('item.retrieved', this.render.bind(this));
    }

});
