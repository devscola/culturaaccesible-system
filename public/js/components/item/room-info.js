Class('Room.Info', {

    Extends: Component,

    initialize: function() {
        Room.Info.Super.call(this, 'roomInfo');
        this.loadRoom();
        this.exhibitionButton = document.getElementById('action');
        this.museumButton = document.getElementById('newMuseum');

        this.museumButton.addEventListener('createMuseum', this.goToNewMuseum.bind(this));
        this.exhibitionButton.addEventListener('started', this.goToNewExhibition.bind(this));
        this.element.addEventListener('edit', this.goToEditForm.bind(this));
        this.element.addEventListener('delete', this.delete.bind(this))
    },

    goToNewMuseum: function() {
        window.location = '/museum';
    },

    goToNewExhibition: function() {
        window.location = '/home';
    },

    render: function(room) {
        this.element.room = room;
    },

    loadRoom: function() {
      var id = this.getRoomId();
      var exhibitionId = this.getExhibitionId();
      var payload = { 'id': id, 'exhibition_id': exhibitionId };
      Bus.publish('room.retrieve', payload);
    },

    getRoomId: function() {
      return this.loadShortUrlData(7);
    },

    getExhibitionId: function() {
      return this.loadShortUrlData(3);
    },

    goToEditForm: function() {
      var parentId = this.loadShortUrlData(7);
      var exhibitionId = this.loadShortUrlData(3);
      window.location = '/exhibition/' + exhibitionId + '/exhibition/' + parentId + '/edit';
    },

    delete: function(item) {
      var payload = {'id': item.detail.id, 'exhibition_id': this.loadShortUrlData(3)};
      Bus.publish('item.delete', payload);
    },

    loadShortUrlData: function(index) {
        var urlString = window.location.href;
        var regexp = /\/(exhibition)(\/)(.*)(\/)(exhibition|room|scene)(\/)(.*)(|\/)(|.*)/;
        var data = regexp.exec(urlString)[index];
        return data;
    },

    subscribe: function() {
        Bus.subscribe('room.retrieved', this.render.bind(this));
        Bus.subscribe('item.deleted', this.goToNewExhibition.bind(this));
    }

});
