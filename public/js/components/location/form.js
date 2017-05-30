Class('Museum.Location', {

    Extends: Component,

    initialize: function() {
        Museum.Location.Super.call(this, 'formulary');
        this.view = document.getElementById('result');
        this.element.addEventListener('submitClicked', this.renderView.bind(this));
    },

    renderView: function(event) {
        this.view.visible = true;
        this.view.location = event.detail;
    }

});
