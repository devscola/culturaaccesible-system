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

    subscribe: function() {
        Bus.subscribe('exhibitions.list.retrieve', this.retrieveList.bind(this));
    }
});
