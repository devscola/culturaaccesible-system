Class('Info.View', {

    Extends: Component,

    initialize: function() {
        Info.View.Super.call(this, 'view');
    },

    render: function(info) {
        this.element.info = info;
        this.show();
    },

    show: function() {
        this.element.visible = true;
    },

    subscribe: function() {
        Bus.subscribe('info.retrieved', this.render.bind(this));
    }

});
