Class('Services.Items', {

    Extends: Service,

    initialize: function() {
        Services.Items.Super.call(this, '/api');
    },

    retrieveItem: function(payload) {
        this.doRequest('/item/retrieve', payload, function(item){
            Bus.publish('item.retrieved', item);
        });
    },

    saveItem: function(item) {
        this.doRequest('/item/add', item, function(result) {
            Bus.publish('item.saved', result);
        });
    },

    subscribe: function() {
        Bus.subscribe('item.save', this.saveItem.bind(this));
        Bus.subscribe('item.retrieve', this.retrieveItem.bind(this));
    }

});
