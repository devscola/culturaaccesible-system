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
      return this.loadShortUrlData(7);
    },

    goToEditForm: function() {
      var parentId = this.loadShortUrlData(7);
      var exhibitionId = this.loadShortUrlData(3);
      window.location = '/exhibition/' + exhibitionId + '/exhibition/' + parentId + '/edit';
    },

    loadShortUrlData: function(index) {
        var urlString = window.location.href;
        var regexp = /\/(exhibition)(\/)(.*)(\/)(exhibition|room|scene)(\/)(.*)(|\/)(|.*)/;
        var data = regexp.exec(urlString)[index];
        return data;
    },

    subscribe: function() {
        Bus.subscribe('room.retrieved', this.render.bind(this));
    }

});
