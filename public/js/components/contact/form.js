Class('Contact.Form', {

    Extends: Component,

    fields: [{"label" : "Phone"}, {"label" : "Email"}, {"label" : "Web"}],

    initialize: function() {
        Contact.Form.Super.call(this, 'contact-form');
        this.element.fields = this.fields;
        this.element.addEventListener('buttonToggled', this.toggleButton.bind(this));
        this.element.addEventListener('submitted', this.renderContact.bind(this));
    },

    toggleButton: function(hasContent) {
      this.element.disableSave = !hasContent;
    },

    renderContact: function(contactInfo) {
      Bus.publish('render.contact', contactInfo.detail);
    },

    subscribe: function() {
    }

});

