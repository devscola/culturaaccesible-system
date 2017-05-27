Class('Museum.Contact', {

    Extends: Component,

    contactDetail: [
        {type: "phone", label: "Phone number", storeInfo: []},
        {type: "email", label: "Email", storeInfo: []},
        {type: "web", label: "Website", storeInfo: []}
    ],

    initialize: function() {
        Museum.Contact.Super.call(this, 'formulary');
        this.element.contactDetail = this.contactDetail;
    }

});
