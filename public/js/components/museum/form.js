Class('Museum.Form', {

    Extends: Component,

    contactFields: {phone: [], email: [], web: []},

    priceFields: {freeEntrance: [], general: [], reduced: []},

    storage: {MON: [], TUE: [], WED: [], THU: [], FRI: [], SAT: [], SUN: []},

    initialize: function() {
        Museum.Form.Super.call(this, 'formulary');
        this.newButton = document.getElementById('newMuseum');
        this.exhibitionButton = document.getElementById('action');
        this.saveButton = document.getElementById('saveMuseum');
        this.result = document.getElementById('result');

        this.infoForm = document.getElementById('info');
        this.locationForm = document.getElementById('location');
        this.contactForm = document.getElementById('contact');
        this.priceForm = document.getElementById('price');
        this.scheduleForm = document.getElementById('schedule');
        this.phone = document.getElementsByClassName('contact-fields')[0];
        this.email = document.getElementsByClassName('contact-fields')[1];
        this.web = document.getElementsByClassName('contact-fields')[2];
        this.freeEntrance = document.getElementsByClassName('price-fields')[0];
        this.general = document.getElementsByClassName('price-fields')[1];
        this.reduced = document.getElementsByClassName('price-fields')[2];

        if (null == this.contactForm){
            this.contactForm = {};
        }
        this.contactForm.contactData = this.contactFields;

        if (null == this.priceForm){
            this.priceForm = {};
        }
        this.priceForm.priceData = this.priceFields;

        if (null == this.scheduleForm){
            this.scheduleForm = {};
        }
        this.scheduleForm.scheduleData = this.storage;

        this.addListeners();
        this.loadEditInfo();
    },

    addListeners: function() {
        this.exhibitionButton.addEventListener('started', this.goToNewExhibition.bind(this));
        this.newButton.addEventListener('createMuseum', this.goToNewMuseum.bind(this));
        this.element.addEventListener('submitted', this.saveMuseum.bind(this));
        this.result.addEventListener('edit', this.showEditableData.bind(this));

        this.element.addEventListener('notEnoughInfo', this.revokeInfo.bind(this));
        this.element.addEventListener('notEnoughLocation', this.revokeLocation.bind(this));
        this.element.addEventListener('enoughInfo', this.storeInfo.bind(this));
        this.element.addEventListener('enoughLocation', this.storeLocation.bind(this));
    },

    loadEditInfo: function() {
        if (this.isEditable()) {
            var museumId = this.getMuseumId();
            this.retrieveMuseum(museumId);
        }
    },

    isEditable: function() {
        var url = window.location.href;
        return url.indexOf('edit') >= 0;
    },

    getMuseumId: function() {
      var url = window.location.href;
      return this.loadShortUrlData(3);
    },

    loadShortUrlData: function(index) {
        var urlString = window.location.href;
        var regexp = /\/(museum)(\/)(.*)(\/)(edit)/;
        var data = regexp.exec(urlString)[index];
        return data;
    },

    retrieveMuseum: function(id) {
        var payload = { 'id': id };
        Bus.publish('museum.retrieve', payload);
    },

    editMuseum: function(museum) {
        this.element.museum = museum;
        this.infoForm.setEditData();
        this.locationForm.setEditData();
        this.phone.setEditData();
        this.email.setEditData();
        this.web.setEditData();
        this.freeEntrance.setEditData();
        this.general.setEditData();
        this.reduced.setEditData();
        this.scheduleForm.setEditData();
    },

    hide: function() {
        this.element.style.display = 'none';
    },

    show: function() {
        this.element.style.display = 'block';
    },

    goToNewMuseum: function() {
        window.location = '/museum';
    },

    goToNewExhibition: function() {
        window.location = '/home';
    },

    saveMuseum: function() {
        if(this.element.editable){
            this.museumData = {id: this.result.museumData.id};
            this.collectData();
            Bus.publish('museum.update', this.museumData);
        }else{
            this.museumData = {};
            this.collectData();
            Bus.publish('museum.save', this.museumData);
        }
        this.hide();
    },

    collectData: function() {
        Object.assign(
            this.museumData,
            {info: this.infoForm.infoData},
            {location: this.locationForm.locationData},
            {contact: this.contactForm.contactData},
            {price: this.priceForm.priceData},
            {schedule: this.scheduleForm.scheduleData}
        );
    },

    showEditableData: function() {
        this.result.visibility = 'hide';
        this.show();
        this.element.editable = true;
        this.scheduleForm.editable = true;
    },

    revokeInfo: function() {
        this.enoughInfo = false;
        this.allowSave();
    },

    revokeLocation: function() {
        this.enoughLocation = false;
        this.allowSave();
    },

    storeInfo: function() {
        this.enoughInfo = true;
        this.allowSave();
    },

    storeLocation: function() {
        this.enoughLocation = true;
        this.allowSave();
    },

    allowSave: function() {
        this.saveButton.active = this.hasEnoughContent();
    },

    hasEnoughContent: function(){
        return (this.enoughInfo && this.enoughLocation);
    },

    subscribe: function() {
        Bus.subscribe('museum.retrieved', this.editMuseum.bind(this));
    }

});
