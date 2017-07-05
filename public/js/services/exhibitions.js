Class('Services.Exhibitions', {

    Extends: Service,

    initialize: function() {
        Services.Exhibitions.Super.call(this, '/api');
    },

    retrieveExhibition: function(payload) {
        this.doRequest('/exhibition/retrieve', payload, function(exhibition){
            Bus.publish('exhibition.retrieved', exhibition);
        });
    },

    retrieveList: function(result) {
        this.doRequest('/exhibition/retrieve-for-list-fake', '', function(result) {
            Bus.publish('exhibitions.list.retrieved', result);
        });
    },

    saveExhibition: function(exhibition) {
        this.doRequest('/exhibition/add', exhibition, function(result) {
            Bus.publish('exhibition.saved', result);
        });
    },

    subscribe: function() {
        Bus.subscribe('exhibition.retrieve', this.retrieveExhibition.bind(this));
        Bus.subscribe('exhibitions.list.retrieve', this.retrieveList.bind(this));
        Bus.subscribe('exhibition.save', this.saveExhibition.bind(this));
    }

});
