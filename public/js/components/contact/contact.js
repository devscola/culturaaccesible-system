Class('Contact.View', {

    Extends: Component,

    initialize: function() {
      Contact.View.Super.call(this, 'contact-view');
      var contact = {};
    },

    render: function(contactInfo) {
      this.element.contact = contactInfo;
      this.showPanel();
    },

    showPanel: function() {
      this.element.visible = true;
    },

    subscribe: function() {
      Bus.subscribe('render.contact', this.render.bind(this));
    }

});
