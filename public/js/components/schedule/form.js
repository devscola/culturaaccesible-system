Class('Museum.Schedule', {

    Extends: Component,

    schedule: [
        {day: 'Monday', hours: []},
        {day: 'Tuesday', hours: []},
        {day: 'Wednesday', hours: []},
        {day: 'Thursday', hours: []},
        {day: 'Friday', hours: []},
        {day: 'Saturday', hours: []},
        {day: 'Sunday', hours: []}
    ],

    initialize: function() {
        Museum.Schedule.Super.call(this, 'formulary');
        this.element.schedule = this.schedule;
        this.hours = document.getElementById('hours');
        this.element.addEventListener('daySelected', this.setDays.bind(this));
        this.result = document.getElementById('result');
        this.result.days = this.schedule;
    },

    setDays: function(days) {
      this.hours.days = days.detail;
    }
});
