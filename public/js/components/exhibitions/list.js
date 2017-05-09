Class('Exhibitions.List', {

    initialize: function() {
        this.exhibitionsContainer = document.getElementById('exhibitions-list');
        this.subscribe();
    },

    render: function(exhibitions) {
        this.empty();
        exhibitions.forEach(function(exhibition) {
            var listItem = document.createElement('li');
            listItem.className = 'exhibition';
            listItem.textContent = exhibition.name;
            this.exhibitionsContainer.appendChild(listItem);
        }.bind(this));
    },

    empty: function() {
        this.exhibitionsContainer.html = '';
    },

    subscribe: function() {
        Bus.subscribe('exhibitions.list.retrieved', this.render.bind(this));
    }
});
