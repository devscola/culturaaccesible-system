Class('Museum.Contact', {

    Extends: Component,

    fields: [
        {name: "phone", label: "Phone number", elements: ["PhoneNumber1"] },
        {name: "email", label: "Email", elements: ["Email1"]},
        {name: "web", label: "Website", elements: ["Web1"]}
    ],

    view: document.getElementById('result'),

    initialize: function() {
        Museum.Contact.Super.call(this, 'formulary');
        this.element.fields = this.fields;
        this.element.addEventListener('buttonToggled', this.toggleButton.bind(this));
        this.element.addEventListener('submitted', this.render.bind(this));
    },

    toggleButton: function(hasContent) {
        this.element.disableSave = !hasContent.detail;
    },

    render: function(contactInfo) {
        this.view.contact = contactInfo.detail;
        this.show();
    },

    show: function() {
        this.view.visible = true;
    }

});
