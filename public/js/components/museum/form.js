Class('Museum.Form', {

    Extends: Component,

    contactFields: {phone: [], email: [], web: []},

    priceFields: {freeEntrance: [], general: [], reduced: []},

    storage: {MON: [], TUE: [], WED: [], THU: [], FRI: [], SAT: [], SUN: []},

    initialize: function() {
        Museum.Form.Super.call(this, 'formulary');
        this.newButton = document.getElementById('newMuseum');
        this.saveButton = document.getElementById('action');
        this.result = document.getElementById('result');

        this.infoForm = document.getElementById('info');
        this.locationForm = document.getElementById('location');
        this.contactForm = document.getElementById('contact');
        this.priceForm = document.getElementById('price');
        this.scheduleForm = document.getElementById('schedule');
        this.contactPhoneForm = document.getElementById('contact-phone');

        this.scheduleForm.scheduleData = this.storage;
        this.contactForm.contactData = this.contactFields;
        this.priceForm.priceData = this.priceFields;

        this.addListeners();
        this.hide();

        if(this.isEditable()){
          this.getMuseum();
        }
    },

    isEditable: function() {
        var url = window.location.href;
        return url.indexOf('edit') >= 0;
    },

    getMuseum: function() {
        let id = this.loadShortUrlData(3);
        let payload = {'id': id};
        Bus.publish('museum.retrieve', payload);
    },

    render: function(museum) {
      this.show();
      this.element.editable = true;
      this.infoForm.setData(museum.info);
      this.locationForm.setData(museum.location);
      console.log(museum.contact)
      this.contactPhoneForm.setData(museum.contact.phone);
    },

    hide: function() {
        this.element.style.display = 'none';
    },

    show: function() {
        this.element.style.display = 'block';
    },

    addListeners: function() {
        this.newButton.addEventListener('createMuseum', this.show.bind(this));
        this.element.addEventListener('submitted', this.saveMuseum.bind(this));
        this.result.addEventListener('edit', this.showEditableData.bind(this));

        this.element.addEventListener('notEnoughInfo', this.revokeInfo.bind(this));
        this.element.addEventListener('notEnoughLocation', this.revokeLocation.bind(this));
        this.element.addEventListener('enoughInfo', this.storeInfo.bind(this));
        this.element.addEventListener('enoughLocation', this.storeLocation.bind(this));
    },

    saveMuseum: function() {
        if(this.element.editable){
            this.museumData = {id: this.result.museumData.id}
            this.collectData()
            Bus.publish('museum.update', this.museumData);
        }else{
            this.museumData = {}
            this.collectData()
            Bus.publish('museum.save', this.museumData);
        }
        this.hide()
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

    loadShortUrlData: function(index) {
        var urlString = window.location.href;
        var regexp = /\/(museum)(\/)(.*)(\/edit)/;
        var data = regexp.exec(urlString)[index];
        return data;
    },

    subscribe: function() {
        Bus.subscribe('museum.retrieved', this.render.bind(this))
    }

});
