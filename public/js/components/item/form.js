Class('Item.Form', {

    Extends: Component,

    initialize: function() {
        Item.Form.Super.call(this, 'formulary');
        this.alert = document.getElementById('alert');
        this.alert.addEventListener('disableFields', this.disableFields.bind(this));
        this.alert.addEventListener('uncheckRoom', this.uncheckRoom.bind(this));
        this.element.addEventListener('submitted', this.save.bind(this));
        this.element.addEventListener('roomAlert', this.showAlert.bind(this));
        this.itemForm = document.getElementById('formulary');
        this.retrieveAnExhibition();
    },

    showAlert: function() {
        this.alert.visibility = 'show';
    },

    show: function(event) {
        this.itemForm.item = event.detail;
        this.itemForm.formVisibility = 'show';
    },

    disableFields: function() {
        this.element.disableItemInput = true;
        this.emptyFields();
    },

    emptyFields: function() {
        this.element.date = '';
        this.element.author = '';
    },

    uncheckRoom: function() {
        document.getElementsByClassName("room")[0].checked = false;
        this.element.disableItemInput = false;
    },

    retrieveAnExhibition: function() {
        var exhibitionId = this.loadExhibitionId();
        var payload = { 'id': exhibitionId };
        Bus.publish('exhibition.retrieve', payload);
    },

    loadExhibitionId: function() {
        return window.location.href.split('/item/')[1];
    },

    renderExhibition: function(exhibition) {
        this.element.exhibition = exhibition;
    },

    save: function(item) {
      Bus.publish('item.save', item.detail);
    },

    subscribe: function() {
        Bus.subscribe('exhibition.retrieved', this.renderExhibition.bind(this));
        Bus.subscribe('item.edit', this.show.bind(this));
    }
});
