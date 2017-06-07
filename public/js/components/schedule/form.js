Class('Museum.Schedule', {

    Extends: Component,

    initialize: function() {
        Museum.Schedule.Super.call(this, 'formulary');
        this.daysForm = document.getElementById('days');
        this.hoursForm = document.getElementById('hours');
        this.result = document.getElementById('result');
        this.action = document.getElementById('action');

        this.storage = {MON: [], TUE: [], WED: [], THU: [], FRI: [], SAT: [], SUN: []};
        this.addListeners();
    },

    addListeners: function() {
        this.element.addEventListener('daySelected', this.deliverDays.bind(this));
        this.element.addEventListener('addClicked', this.arrangeSchedule.bind(this));
        this.element.addEventListener('submitted', this.hide.bind(this));
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
        this.result.days = this.selectedDays;
        this.action.saveDisabled = null;
        this.storeSchedule();
        this.generateRenderSchedule();
        this.showSchedule();
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

    generateRenderSchedule: function() {
        var schedule = [];
        for (var day in this.storage) {
            if (this.storage[day].length > 0) {
                var object = {};
                object.day = day;
                object.hours = this.storage[day];
                schedule.push(object);
            }
        }
        this.result.schedule = schedule;
    },

    showSchedule: function() {
        this.result.visible = true;
        this.resetDays();
    },

    resetDays: function() {
        this.daysForm.selectedDays = [];
        this.daysForm.checked = true;
        this.daysForm.checked = false;
    },

    hide: function() {
        this.daysForm.visibility = 'hide';
        this.hoursForm.visibility = 'hide';
    }
});
