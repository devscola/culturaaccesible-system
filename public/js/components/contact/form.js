Class('Museum.Contact', {

    Extends: Component,

    contactDetail: [
        {type: "phone", label: "Phone number"},
        {type: "email", label: "Email"},
        {type: "web", label: "Website"}
    ],

    initialize: function() {
        Museum.Contact.Super.call(this, 'formulary');
        this.element.contactDetail = this.contactDetail;
    }

});
