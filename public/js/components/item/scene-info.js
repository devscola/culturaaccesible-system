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
      return this.loadParentId();
    },

    goToEditForm: function() {
      var parentId = this.loadParentId();
      var exhibitionId = this.loadExhibitionId();
      var parentClass = this.loadParentClass();
      window.location = '/exhibition/' + exhibitionId + '/' + parentClass + '/' + parentId + '/edit';
    },

    loadExhibitionId: function() {
        var urlString = window.location.href;
        var regexp = /\/(exhibition)(\/)(.*)(\/)(exhibition|room|scene|subscene)(\/)(.*)(|\/)(|.*)/;
        var urlParentId = regexp.exec(urlString)[3];
        return urlParentId;
    },

    loadParentId: function() {
        var urlString = window.location.href;
        var regexp = /\/(exhibition)(\/)(.*)(\/)(exhibition|room|scene|subscene)(\/)(.*)(|\/)(|.*)/;
        var urlParentId = regexp.exec(urlString)[7];
        return urlParentId;
    },

    loadParentClass: function() {
        var urlString = window.location.href;
        var regexp = /\/(exhibition)(\/)(.*)(\/)(exhibition|room|scene|subscene)(\/)(.*)(|\/)(|.*)/;
        var urlParentType = regexp.exec(urlString)[5];
        return urlParentType;
    },

    subscribe: function() {
        Bus.subscribe('item.retrieved', this.render.bind(this));
    }

});
