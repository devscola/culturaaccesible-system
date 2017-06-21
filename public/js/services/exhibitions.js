Class('Services.Exhibitions', {

    Extends: Service,

    initialize: function() {
        Services.Exhibitions.Super.call(this, '/api');
    },

    retrieveList: function(result) {
        this.doRequest('/exhibition/list', '', function(result) {
            Bus.publish('exhibitions.list.retrieved', result);
        });
    },

    saveExhibition: function(exhibition) {
        this.doRequest('/exhibition/add', exhibition, function(result) {
            Bus.publish('exhibition.saved', result);
        });
    },

    subscribe: function() {
        Bus.subscribe('exhibitions.list.retrieve', this.retrieveList.bind(this));
        Bus.subscribe('exhibition.save', this.saveExhibition.bind(this));
    }

});
