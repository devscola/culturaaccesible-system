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
                    title: 'El placer de soñar',
                    location: 'C/ Cuenca Benimaclet',
                    short_description: 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor',
                    date_start: '02/01/2017',
                    date_finish: '02/02/2017',
                    type: 'Sculpture',
                    beacon: '0001',
                    description: 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'
                };

        Bus.publish('exhibition.submitted.retrieved', result);
    },

    subscribe: function() {
        Bus.subscribe('exhibitions.list.retrieve', this.retrieveList.bind(this));
        Bus.subscribe('exhibition.save', this.retrievePanel.bind(this));
    }

});
