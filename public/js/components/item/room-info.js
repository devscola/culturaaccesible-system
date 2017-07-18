Class('Room.Info', {

    Extends: Component,

    initialize: function() {
        Room.Info.Super.call(this, 'roomInfo');
        this.loadRoom();
        this.element.addEventListener('edit', this.goToEditForm.bind(this));

    },

    render: function(room) {
        this.element.room = room;
    },

    loadRoom: function() {
      var id = this.getRoomId();
      var payload = { 'id': id };
      Bus.publish('room.retrieve', payload);
    },

    getRoomId: function() {
      return this.loadParentId();
    },

    goToEditForm: function() {
      var parentId = this.loadParentId();
      var exhibitionId = this.loadExhibitionId();
      window.location = '/exhibition/' + exhibitionId + '/exhibition/' + parentId + '/edit';
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

    subscribe: function() {
        Bus.subscribe('room.retrieved', this.render.bind(this));
    }

});
