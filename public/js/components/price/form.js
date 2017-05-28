Class('Museum.Price', {

    Extends: Component,

    priceDetail: [
        {type: "freeEntrance", label: "Free entrance"},
        {type: "general", label: "General"},
        {type: "reduced", label: "Reduced"}
    ],

    initialize: function() {
        Museum.Price.Super.call(this, 'formulary');
        this.element.priceDetail = this.priceDetail;
    }

});
