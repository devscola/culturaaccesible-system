Class('Museum.Schedule', {

    Extends: Component,

    initialize: function() {
        Museum.Schedule.Super.call(this, 'formulary');
        this.hours = document.getElementById('hours');
        this.result = document.getElementById('result');

        this.element.addEventListener('daySelected', this.setDays.bind(this));
        this.element.addEventListener('scheduleGenerated', this.renderSchedule.bind(this));


    },

    setDays: function(days) {
      this.hours.days = days.detail;
    },

    renderSchedule: function(event){
        var schedule = event.detail;
        this.result.schedule = schedule;
    },
});
