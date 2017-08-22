Class('Services.Museums', {

    Extends: Service,

    initialize: function() {
        Services.Museums.Super.call(this, '/api');
    },

    save: function(museum_data) {
        this.doRequest('/museum/add', museum_data, function(result) {
            Bus.publish('museum.saved', result);
        });
    },

    update: function(museum_data) {
        this.doRequest('/museum/update', museum_data, function(result) {
            Bus.publish('museum.saved', result);
        });
    },

    retrieveList: function(result) {
        this.doRequest('/museum/list', '', function(result) {
            Bus.publish('museum.list.retrieved', result);
        });
    },

    retrieve: function(museum_data) {
        this.doRequest('/museum/retrieve', museum_data, function(museum) {
            Bus.publish('museum.retrieved', museum);
        });
    },

    subscribe: function() {
        Bus.subscribe('museum.save', this.save.bind(this));
        Bus.subscribe('museum.update', this.update.bind(this));
        Bus.subscribe('museum.retrieve', this.retrieve.bind(this));
        Bus.subscribe('museum.list.retrieve', this.retrieveList.bind(this));
    }

});
