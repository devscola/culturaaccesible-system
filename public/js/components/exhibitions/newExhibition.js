Class('NewExhibition.Form', {

    initialize: function() {
        this.element = document.getElementById('new-exhibition');
        this.element.addEventListener('click', this.publishClicked.bind(this));
    },

    publishClicked: function() {
        Bus.publish('exhibition.new');
    }

});
