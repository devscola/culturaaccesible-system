Class('Museum.Form', {

    Extends: Component,

    contactDetail: [
        {type: "phone", label: "Phone number"},
        {type: "email", label: "Email"},
        {type: "web", label: "Website"}
    ],

    priceDetail: [
        {type: "freeEntrance", label: "Free entrance"},
        {type: "general", label: "General"},
        {type: "reduced", label: "Reduced"}
    ],

    priceFields: {freeEntrance: [], general: [], reduced: []},

    contactFields: {phone: [], email: [], web: []},

    storage: {MON: [], TUE: [], WED: [], THU: [], FRI: [], SAT: [], SUN: []},

    initialize: function() {
        Museum.Form.Super.call(this, 'formulary');
        this.newButton = document.getElementById('newMuseum');
        this.saveButton = document.getElementById('action');
        this.result = document.getElementById('result');
        this.infoValues = {};
        this.locationValues = {};

        this.infoForm = document.getElementById('info');
        this.locationForm = document.getElementById('location');
        this.contactForm = document.getElementById('contact');
        this.priceForm = document.getElementById('price');
        this.scheduleForm = document.getElementById('schedule');

        this.daysForm = document.getElementById('days');
        this.hoursForm = document.getElementById('hours');

        this.contactForm.contactDetail = this.contactDetail;
        this.contactForm.contactData = this.contactFields;
        this.priceForm.priceDetail = this.priceDetail;
        this.priceForm.storage = this.priceFields;


        this.addListeners();
        this.hide();
    },

    hide: function() {
        this.element.style.display = 'none';
    },

    show: function() {
        this.element.style.display = 'block';
    },

    addListeners: function() {
        this.newButton.addEventListener('click', this.show.bind(this));
        this.element.addEventListener('submit', this.collectData.bind(this));
        this.element.addEventListener('notEnoughInfo', this.revokeInfo.bind(this));
        this.element.addEventListener('notEnoughLocation', this.revokeLocation.bind(this));

        this.element.addEventListener('enoughInfo', this.storeInfo.bind(this));
        this.element.addEventListener('enoughLocation', this.storeLocation.bind(this));

        this.element.addEventListener('daySelected', this.deliverDays.bind(this));
        this.element.addEventListener('addClicked', this.arrangeSchedule.bind(this));
    },

    collectData: function() {
        this.museumData = {};
        Object.assign(
            this.museumData,
            this.infoForm.infoData,
            this.locationForm.locationData,
            this.contactForm.contactData
            )

        console.log(this.museumData);
        this.showsInfo();
    },

    showsInfo: function() {
        this.hide();
        this.result.visibility = 'show';
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
    },

    deliverDays: function(days) {
        this.selectedDays = days.detail;
        this.hoursForm.days = this.selectedDays;
        this.polymerWorkaround();
    },

    polymerWorkaround: function() {
        var daysHours = this.hoursForm.days;
        this.hoursForm.days = [];
        this.hoursForm.days = daysHours;
    },

    arrangeSchedule: function(event) {
        this.openingHours = event.detail;
        this.storeSchedule();
        this.resetDays();
    },

    storeSchedule: function() {
        this.selectedDays.forEach(function(day) {
            this.storage[day].push(this.openingHours);
            var duplicateHoursRemoved = this.storage[day].filter(function(hours, index, self) {
                return index == self.indexOf(hours);
            });
            this.storage[day] = duplicateHoursRemoved.sort();
        }.bind(this));
    },

    resetDays: function() {
        this.daysForm.selectedDays = [];
        this.daysForm.checked = true;
        this.daysForm.checked = false;
    }

});
