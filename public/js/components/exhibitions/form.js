Class('Exhibitions.Form', {

    initialize: function() {
        this.name = document.getElementById('name');
        this.location = document.getElementById('location');
        this.submit = document.getElementById('submit-form');

        this.addListeners();
    },

    addListeners: function() {
        this.name.addEventListener('input', function() {
            this.allowSubmit();
        }.bind(this));
        this.location.addEventListener('input', function() {
            this.allowSubmit();
        }.bind(this));
    },

    allowSubmit: function() {
        var nameLength = this.name.value.length;
        var locationLength = this.location.value.length;

        if (nameLength > 0 && locationLength > 0) {
            this.activateSubmit();
        }
    },

    activateSubmit: function() {
        this.submit.disabled = false;
    }

});
