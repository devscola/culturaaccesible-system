Class('Museum.Contact', {

    Extends: Component,

    fields: [{"label" : "Phone"}, {"label" : "Email"}, {"label" : "Web"}],

    view: document.getElementById('result'),

    initialize: function() {
        Museum.Contact.Super.call(this, 'formulary');
        this.element.fields = this.fields;
        this.element.addEventListener('buttonToggled', this.toggleButton.bind(this));
        this.element.addEventListener('submitted', this.renderContact.bind(this));
    },

    toggleButton: function(hasContent) {
        this.element.disableSave = !hasContent;
    },

    render: function(contactInfo) {
        this.view.contact = contactInfo;
        this.show();
    },

    show: function() {
        this.view.visible = true;
    },

    renderContact: function(contactInfo) {
        Bus.publish('render.contact', contactInfo.detail);
    },

    subscribe: function() {
        Bus.subscribe('render.contact', this.render.bind(this));
    }


});
