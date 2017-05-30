Class('Museum.Schedule', {

    Extends: Component,

    initialize: function() {
        Museum.Schedule.Super.call(this, 'formulary');
        this.hours = document.getElementById('hours');
        this.element.addEventListener('daySelected', this.setDays.bind(this));
    },

    days: [
        {day: 'LUN', hours: ['09:00 - 13:00', '14:00 - 21:00']},
        {day: 'MAR', hours: ['14:00 - 21:00']},
        {day: 'MIE', hours: []},
        {day: 'JUE', hours: []},
        {day: 'SAB', hours: ['14:00 - 21:00']},
        {day: 'DOM', hours: []}
    ],

    initialize: function() {
        Museum.Schedule.Super.call(this, 'formulary');
        this.result = document.getElementById('result');
        this.result.days = this.days;
    }

    setDays: function(days) {
      this.hours.days = days.detail;
    }
});
