Class('Museum.Price', {

    Extends: Component,

    fields: [{"name": "free-entrance", "label" : "Free entrance"}, {"name": "general", "label" : "General"}, {"name": "reduced", "label" : "Reduced"}],

    view: document.getElementById('result'),

    initialize: function() {
        Museum.Price.Super.call(this, 'formulary');
        this.element.fields = this.fields;
        this.element.addEventListener('submitted', this.renderPrice.bind(this));
        this.element.addEventListener('buttonToggled', this.toggleButton.bind(this));
    },

    renderPrice: function(info) {
        this.view.priceInfo = info.detail;
        this.view.visible = true;
    },

    toggleButton: function(hasContent) {
      this.element.disableSave = !hasContent.detail;
    }

});
