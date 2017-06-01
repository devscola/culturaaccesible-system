Class('Museum.Form', {

    Extends: Component,

    initialize: function() {
        Museum.Form.Super.call(this, 'formulary');
        this.saveButton = document.getElementById('action');
        this.addListeners();
    },

    addListeners: function() {
        this.element.addEventListener('notEnoughInfo', this.revokeInfo.bind(this));
        this.element.addEventListener('notEnoughLocation', this.revokeLocation.bind(this));

        this.element.addEventListener('enoughInfo', this.storeInfo.bind(this));
        this.element.addEventListener('enoughLocation', this.storeLocation.bind(this));
    },

    revokeInfo: function() {
        this.enoughInfo = false;
        this.verifyEnoughContent();
    },

    revokeLocation: function() {
        this.enoughLocation = false;
        this.verifyEnoughContent();
    },

    storeInfo: function(event) {
        this.infoValues = event.detail;
        this.enoughInfo = true;
        this.verifyEnoughContent();
    },

    storeLocation: function(event) {
        this.locationValues = event.detail;
        this.enoughLocation = true;
        this.verifyEnoughContent();
    },

    verifyEnoughContent: function() {
        if (this.enoughInfo && this.enoughLocation) {
            this.allowSubmit();
        } else {
            this.disallowSubmit();
        }
    },

    allowSubmit: function() {
        this.saveButton.active = true;
    },

    disallowSubmit: function() {
        this.saveButton.active = false;
    }

});
