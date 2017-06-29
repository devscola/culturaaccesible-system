Class('Services.Items', {

    Extends: Service,

    initialize: function() {
        Services.Items.Super.call(this, '/api');
    },

    saveItem: function(item) {
        this.doRequest('/item/add', item, function(result) {
            Bus.publish('item.saved', result);
        });
    },

    subscribe: function() {
        Bus.subscribe('item.save', this.saveItem.bind(this));
    }

});
