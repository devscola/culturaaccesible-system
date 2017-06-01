Class('Museum.Form', {

    Extends: Component,

    initialize: function() {
        Museum.Form.Super.call(this, 'formulary');

        this.saveButton = document.getElementById('action');
        this.infoValues = {};
        this.locationValues = {};

        this.addListeners();
    },

    addListeners: function() {
        this.element.addEventListener('validInfo', this.storeInfo.bind(this));
        this.element.addEventListener('validLocation', this.storeLocation.bind(this));
    },

    storeInfo: function(event) {
        this.infoValues = event.detail;
        this.verifyEnoughContent();
    },

    storeLocation: function(event) {
        this.locationValues = event.detail;
        this.verifyEnoughContent();
    },

    verifyEnoughContent: function() {
        var infoLength = Object.keys(this.infoValues).length;
        var locationLength = Object.keys(this.locationValues).length;

        if (infoLength > 0 && locationLength > 0) {
            this.saveButton.active = true;
        }
    }
});
