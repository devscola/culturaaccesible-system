Class('Museum.Schedule', {

    Extends: Component,


    initialize: function() {
        Museum.Schedule.Super.call(this, 'formulary');
        this.hours = document.getElementById('hours');
        this.element.addEventListener('daySelected', this.setDays.bind(this));
    },

    setDays: function(days) {
      this.hours.days = days.detail;
    }
});
