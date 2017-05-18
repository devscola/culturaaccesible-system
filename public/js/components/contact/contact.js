Class('Contact.View', {

    Extends: Component,

    initialize: function() {
      Contact.View.Super.call(this, 'contact-view');
      var contact = {
        'phone' : '963456456',
        'email' : 'fake@mail.com',
        'web' : 'webfake.com'
      };
      this.render(contact);
    },

    render: function(contact) {
      this.element.contact = contact;
      this.showPanel();
    },

    showPanel: function() {
      this.element.visible = true;
    },

    subscribe: function() {

    }

});
