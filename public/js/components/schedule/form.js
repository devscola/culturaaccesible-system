Class('Museum.Schedule', {

    Extends: Component,

    schedule: [
        {day: 'Monday', hours: ['09:00 - 13:00', '14:00 - 21:00']},
        {day: 'Tuesday', hours: ['14:00 - 21:00']},
        {day: 'Wednesday', hours: []},
        {day: 'Thursday', hours: []},
        {day: 'Friday', hours: ['14:00 - 21:00']},
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
