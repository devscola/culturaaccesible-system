Class('Museum.Contact', {

    Extends: Component,

    contactDetail: [
        {type: "phone", label: "Phone number"},
        {type: "email", label: "Email"},
        {type: "web", label: "Website"}
    ],

    fields: {
        phone: [],
        email: [],
        web: []
    },

    initialize: function() {
        Museum.Contact.Super.call(this, 'formulary');
        this.element.detail = this.contactDetail;
        this.element.storeInfo = this.fields;
    }

});
