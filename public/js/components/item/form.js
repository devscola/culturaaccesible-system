Class('Item.Form', {

    Extends: Component,

    initialize: function() {
        Item.Form.Super.call(this, 'formulary');
        this.element.addEventListener('submitted', this.save.bind(this));
    },

    save: function(item) {
        Bus.publish('item.save', item.detail);
    }

});
