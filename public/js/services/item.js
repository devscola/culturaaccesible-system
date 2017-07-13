Class('Services.Items', {

    Extends: Service,

    initialize: function() {
        Services.Items.Super.call(this, '/api');
    },

    retrieveItem: function(payload) {
        this.doRequest('/scene/retrieve', payload, function(item){
            Bus.publish('item.retrieved', item);
        });
    },

    retrieveRoom: function(payload) {
        this.doRequest('/room/retrieve', payload, function(room){
            Bus.publish('room.retrieved', room);
            Bus.publish('room.retrieved.editable', room);

        });
    },

    saveItem: function(item) {
        this.doRequest('/item/add', item, function(result) {
            Bus.publish('item.saved', result);
        });
    },

    updateItem: function(item) {
        this.doRequest('/item/update', item, function(result) {
            Bus.publish('item.saved', result);
        });
    },

    subscribe: function() {
        Bus.subscribe('item.save', this.saveItem.bind(this));
        Bus.subscribe('item.update', this.updateItem.bind(this));
        Bus.subscribe('item.retrieve', this.retrieveItem.bind(this));
        Bus.subscribe('room.retrieve', this.retrieveRoom.bind(this));

    }

});
