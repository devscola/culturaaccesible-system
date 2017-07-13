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
      var url = window.location.href;
      return url.split('/scene/')[1];
    },

    goToEditForm: function() {
      var url = '/scene/' + this.getSceneId() + '/edit';
      window.location = url;
    },

    subscribe: function() {
        Bus.subscribe('item.retrieved', this.render.bind(this));
    }

});
