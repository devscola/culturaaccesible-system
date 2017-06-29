Class('Item.View', {

    Extends: Component,

    initialize: function() {
        Item.View.Super.call(this, 'result');
    },

    render: function(item) {
        this.element.item = item;
        this.show();
    },

    show: function() {
        this.element.visible = true;
    },

    subscribe: function() {
        Bus.subscribe('item.saved', this.render.bind(this));
    }

});
