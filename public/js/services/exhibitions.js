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

    retrievePanel: function() {
        result = {
            show: 'On',
            name: 'El placer de soñar',
            location: 'C/ Cuenca Benimaclet',
            shortDescription: 'Lorem ipsum dolor sit amet, consectetur adipisicing elit',
            dateStart: '02/01/2017',
            dateFinish: '02/02/2017',
            type: 'Sculpture',
            beacon: '0001',
            description: 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. '
        };

        Bus.publish('exhibition.saved', result);
    },

    subscribe: function() {
        Bus.subscribe('exhibitions.list.retrieve', this.retrieveList.bind(this));
        Bus.subscribe('exhibition.save', this.retrievePanel.bind(this));
    }

});
