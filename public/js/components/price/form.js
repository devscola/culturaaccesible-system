Class('Museum.Price', {

    Extends: Component,

    priceDetail: [
        {type: "freeEntrance", label: "Free entrance"},
        {type: "general", label: "General"},
        {type: "reduced", label: "Reduced"}
    ],

    fields: {
        freeEntrance: [],
        general: [],
        reduced: []
    },

    initialize: function() {
        Museum.Price.Super.call(this, 'formulary');
        this.element.detail = this.priceDetail;
        this.element.storeInfo = this.fields;
    }

});
