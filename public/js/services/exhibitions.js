Class('Services.Exhibitions', {

    Extends: Service,

    initialize: function() {
        Services.Exhibitions.Super.call(this, '/home');
    },

    retrieveList: function() {
        result = [
            {name: 'Some exhibition'},
            {name: 'Some another exhibition'}
        ];

        Bus.publish('exhibitions.list.retrieved', result);
    },

    saveExhibition: function(exhibition) {
        result = exhibition.detail;
        Bus.publish('exhibition.saved', result);
    },

    subscribe: function() {
        Bus.subscribe('exhibitions.list.retrieve', this.retrieveList.bind(this));
        Bus.subscribe('exhibition.save', this.saveExhibition.bind(this));
    }

});
