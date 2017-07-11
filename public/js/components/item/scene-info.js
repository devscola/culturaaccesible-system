Class('Scene.Info', {

    Extends: Component,

    initialize: function() {
        Scene.Info.Super.call(this, 'sceneInfo');
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

    subscribe: function() {
        Bus.subscribe('item.retrieved', this.render.bind(this));
    }

});
