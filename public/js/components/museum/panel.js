Class('Museum.View', {

    Extends: Component,

    initialize: function() {
        Museum.View.Super.call(this, 'result');
    },

    render: function(museumData) {
        this.element.museumData = museumData;
        this.element.visibility = 'show';
        Bus.publish('museum.list.retrieve');
    },

    subscribe: function() {
        Bus.subscribe('museum.saved', this.render.bind(this));
    }

});
