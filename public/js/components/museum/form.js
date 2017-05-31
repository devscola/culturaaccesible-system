Class('Museum.Form', {

    Extends: Component,

    initialize: function() {
        Museum.Form.Super.call(this, 'formulary');
        this.element.addEventListener('validInfo', this.print.bind(this));
    },

    print: function(event) {
        event.preventDefault();
        console.log(event.detail);
    }

});
