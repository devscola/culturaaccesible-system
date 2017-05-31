Class('Museum.Info', {

    Extends: Component,

    view: document.getElementById('result'),

    initialize: function() {
        Museum.Info.Super.call(this, 'formulary');
        this.element.addEventListener('submitted', this.submitInfo.bind(this));
    },

    submitInfo: function(info) {
        Bus.publish('info.retrieved', info.detail);
    },

    render: function(info) {
        this.view.info = info;
        this.show();
    },

    show: function() {
        this.view.visible = true;
    },

    subscribe: function() {
        Bus.subscribe('info.retrieved', this.render.bind(this));
    }

});
