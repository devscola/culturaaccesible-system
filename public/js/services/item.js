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

    retrieveItemFromSubscene: function(payload) {
        this.doRequest('/scene/retrieve', payload, function(item){
            Bus.publish('subscene.scene.retrieved', item);
        });
    },

    retrieveScene: function(payload) {
        this.doRequest('/scene/retrieve', payload, function(item){
            Bus.publish('subscene.retrieved', item);
        });
    },

    retrieveEditableScene: function(payload) {
        this.doRequest('/scene/retrieve', payload, function(item){
            Bus.publish('scene.retrieved.editable', item);
        });
    },

    retrieveRoom: function(payload) {
        this.doRequest('/room/retrieve', payload, function(room){
            Bus.publish('room.retrieved', room);
        });
    },

    retrieveEditableRoom: function(payload) {
        this.doRequest('/room/retrieve', payload, function(room){
            Bus.publish('room.retrieved.editable', room);
        });
    },

    retrieveNextNumber: function(payload) {
        this.doRequest('/exhibition/retrieve-next-ordinal', payload, function(data) {
            Bus.publish('next.number.retrieved', data['next_child']);
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
        Bus.subscribe('subscene.scene.retrieve', this.retrieveItemFromSubscene.bind(this));
        Bus.subscribe('subscene.retrieve', this.retrieveScene.bind(this));
        Bus.subscribe('item.retrieve.editable', this.retrieveEditableScene.bind(this));
        Bus.subscribe('room.retrieve.editable', this.retrieveEditableRoom.bind(this));
        Bus.subscribe('room.retrieve', this.retrieveRoom.bind(this));
        Bus.subscribe('next.number.retrieve', this.retrieveNextNumber.bind(this));
    }
});
