Class('Contact.Form', {

    Extends: Component,

    initialize: function() {
        Contact.Form.Super.call(this, 'contact-form');
        this.element.inputs = [
          {
            "label" : "Phone"
          },
          {
            "label" : "Email"
          },
          {
            "label" : "Web"
          }
        ]
    },

    subscribe: function() {
    }

});

