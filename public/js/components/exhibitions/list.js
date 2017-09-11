Class('Exhibitions.List', {

    Extends: Component,

    initialize: function() {
        Exhibitions.List.Super.call(this, 'listing');
        this.element.exhibitionsList = [];
        this.element.museumList = [];
        this.retrieve();
    },

    render: function(exhibitions) {
        exhibitions.forEach(exhibition => {
            var payload = {"id": exhibition.id};
            Bus.publish('exhibition.for.list.retrieve', payload);
        })
    },

    renderMuseums: function(museums) {
      this.element.museumList = museums;
    },

    addExhibitionChildren: function(exhibition){
        this.element.exhibitionsList.push(exhibition);
        this.element.exhibitionsList.sort( function(a,b) {
                var time_a = new Date(a.creation_date).getTime();
                var time_b = new Date(b.creation_date).getTime();
            return ( time_a > time_b );
        })
        this.polymerWorkAround();
    },

    polymerWorkAround: function(){
        var temporary = this.element.exhibitionsList;
        this.element.exhibitionsList = [];
        this.element.exhibitionsList = temporary;
    },

    refresh: function() {
        Bus.publish('exhibitions.list.retrieve');
    },

    retrieve: function() {
        Bus.publish('exhibitions.list.retrieve');
        Bus.publish('museum.list.retrieve');
    },

    subscribe: function() {
        Bus.subscribe('exhibitions.list.retrieved', this.render.bind(this));
        Bus.subscribe('exhibition.for.list.retrieved', this.addExhibitionChildren.bind(this));
        Bus.subscribe('museum.list.retrieved', this.renderMuseums.bind(this));
        Bus.subscribe('exhibition.saved', this.refresh.bind(this));
    }
});
