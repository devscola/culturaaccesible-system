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
        this.element.addEventListener('addClicked', this.storeSchedule.bind(this));
        this.element.addEventListener('scheduleGenerated', this.renderSchedule.bind(this));
    },

    setDays: function(days) {
        this.selectedDays = days.detail;
        this.hours.days = this.selectedDays;
    },

    renderSchedule: function(event){
        var schedule = event.detail;
        this.result.schedule = schedule;
    },

    storeSchedule: function(event) {
        this.result.days = this.selectedDays;
        var openingHours = event.detail;
        var selectedDays = this.selectedDays;
        var schedule = [];
        var storage = this.storage;

        selectedDays.forEach(function(day) {
            storage[day].push(openingHours);
        });

        for (var day in storage) {
            if (storage[day].length != 0) {
                var object = {};
                object.day = day;
                object.hours = storage[day];
                schedule.push(object);            
            }
        };

        this.storage = storage;
        this.result.schedule = schedule;

        this.result.visible = true;
        this.resetDays();
    },
    
    resetDays: function() {
        this.days.selectedDays = [];
        this.days.checked = true;
        this.days.checked = false;
    }
});
