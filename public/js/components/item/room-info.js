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
      var url = window.location.href;
      return url.split('/room/')[1];
    },

    goToEditForm: function() {
      var url = '/room/' + this.getRoomId() + '/edit';
      window.location = url;
    },

    subscribe: function() {
        Bus.subscribe('room.retrieved', this.render.bind(this));
    }

});
