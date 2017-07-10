Class('Room.Info', {

    Extends: Component,

    initialize: function() {
        Room.Info.Super.call(this, 'roomInfo');
        this.loadRoom();
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
      var url = window.location.href;
      return url.split('/room/')[1];
    },

    subscribe: function() {
        Bus.subscribe('room.retrieved', this.render.bind(this));
    }

});
