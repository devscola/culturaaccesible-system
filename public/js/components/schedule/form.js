Class('Museum.Schedule', {

    Extends: Component,

    initialize: function() {
        Museum.Schedule.Super.call(this, 'formulary');
        this.days = document.getElementById('days');
        this.hours = document.getElementById('hours');
        this.result = document.getElementById('result');
        this.selectedDays = [];
        this.openingHours = [];
        this.storage = {MON: [], TUE: [], WED: [], THU: [], FRI: [], SAT: [], SUN: []};
        this.addListeners();
    },

    addListeners: function() {
        this.element.addEventListener('daySelected', this.setDays.bind(this));
        this.element.addEventListener('addClicked', this.arrangeSchedule.bind(this));
    },

    setDays: function(days) {
        this.selectedDays = days.detail;
        this.hours.days = this.selectedDays;
        var daysHours = this.hours.days;
        this.hours.days = [];
        this.hours.days = daysHours;
    },

    arrangeSchedule: function(event) {
        this.result.days = this.selectedDays;
        this.openingHours = event.detail;
        this.storeSchedule();
        this.generateRenderSchedule(this.storage);
        this.showSchedule();
    },

    storeSchedule: function() {
        var openingHours = this.openingHours;
        var selectedDays = this.selectedDays;
        var storage = this.storage;

        selectedDays.forEach(function(day) {
            storage[day].push(openingHours);
            var duplicateHoursRemoved = storage[day].filter(function(hours, index, self) {
                return index == self.indexOf(hours);
            });
            storage[day] = duplicateHoursRemoved.sort();   
        });
        this.storage = storage;
    },

    generateRenderSchedule: function(storage) {
        var schedule = [];
        for (var day in storage) {
            if (storage[day].length !== 0) {
                var object = {};
                object.day = day;
                object.hours = storage[day];
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
        this.days.selectedDays = [];
        this.days.checked = true;
        this.days.checked = false;
    }
});
