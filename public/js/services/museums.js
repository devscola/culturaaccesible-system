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

    retrieveAll: function() {
        this.doRequest('/museum/list', '', function(museums) {
            Bus.publish('museums.retrieved', museums);
        });
    },

    subscribe: function() {
        Bus.subscribe('museum.save', this.save.bind(this));
        Bus.subscribe('museum.update', this.update.bind(this));
        Bus.subscribe('museums.retrieve', this.retrieveAll.bind(this));
    }

});
