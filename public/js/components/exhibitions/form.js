Class('Exhibitions.Form', {

    Extends: Component,

    initialize: function() {
        Exhibitions.Form.Super.call(this, 'exhibition-form');
        this.exhibitionForm = document.getElementById('formulary');
        this.exhibitionButton = document.getElementById('action');

        this.exhibitionForm.addEventListener('submitted', this.save.bind(this));
        this.exhibitionButton.addEventListener('started', this.show.bind(this));
        this.loadEditInfo();
        this.retrieveAllMuseums();
    },

    show: function(event) {
        this.exhibitionForm.exhibition = event.detail;
        this.exhibitionForm.visible = true;
    },

    hide: function() {
        this.exhibitionForm.visible = false;
    },

    save: function(exhibition) {
        Bus.publish('exhibition.save', exhibition.detail);
        this.hide();
    },

    showForm: function() {
      this.exhibitionForm.visible = true;
    },

    editExhibition: function(exhibition) {
        this.exhibitionForm.exhibitionId = exhibition.id;
        this.exhibitionForm.name = exhibition.name;
        this.exhibitionForm.description = exhibition.description;
        this.exhibitionForm.image = exhibition.image;
        this.exhibitionForm.beacon = exhibition.beacon;
        document.getElementsByClassName("show")[0].checked = exhibition.show;
        this.exhibitionForm.museumValue = exhibition.museum.id;
        this.exhibitionForm.short_description = exhibition.short_description;
        this.exhibitionForm.typeValue = exhibition.type;
        this.exhibitionForm.date_start = exhibition.date_start;
        this.exhibitionForm.date_finish = exhibition.date_finish;
        this.showForm();
    },

    isEditable: function() {
        var url = window.location.href;
        return url.indexOf('edit') >= 0;
    },

    loadEditInfo: function() {
        if (this.isEditable()) {
            var exhibitionId = this.getExhibitionId();
            this.retrieveExhibition(exhibitionId);
        }
    },

    getExhibitionId: function() {
      var url = window.location.href;
      return this.loadShortUrlData(3);
    },

    retrieveExhibition: function(id) {
        var payload = { 'id': id };
        Bus.publish('exhibition.retrieve', payload);
    },

    loadShortUrlData: function(index) {
        var urlString = window.location.href;
        var regexp = /\/(exhibition)(\/)(.*)(\/)/;
        var data = regexp.exec(urlString)[index];
        return data;
    },

    retrieveAllMuseums: function() {
        Bus.publish('museum.list.retrieve');
    },

    addMuseumsList: function(museums) {
        this.exhibitionForm.museums = museums;
    },

    subscribe: function() {
        Bus.subscribe('exhibition.retrieved', this.editExhibition.bind(this));
        Bus.subscribe('exhibition.edit', this.show.bind(this));
        Bus.subscribe('museum.list.retrieved', this.addMuseumsList.bind(this));
    }

});
