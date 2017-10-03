Class('Exhibitions.Form', {

    Extends: Component,

    initialize: function() {
        Exhibitions.Form.Super.call(this, 'exhibition-form');
        this.exhibitionForm = document.getElementById('formulary');
        this.exhibitionButton = document.getElementById('action');
        this.museumButton = document.getElementById('newMuseum');

        this.museumButton.addEventListener('createMuseum', this.goToNewMuseum.bind(this));
        this.exhibitionForm.addEventListener('submitted', this.save.bind(this));
        this.exhibitionButton.addEventListener('started', this.show.bind(this));
        this.loadEditInfo();
        this.retrieveAllMuseums();
    },

    show: function(event) {
        urlLocation = window.location.pathname;
        isInRoot = ( urlLocation == '/' );
        isInHome = ( urlLocation == '/home' );
        if (!isInHome && !isInRoot){
            this.exhibitionForm.exhibition = event.detail;
            this.exhibitionForm.visible = true;
        }else{
            this.goToNewExhibition();
        }
    },

    goToNewMuseum: function() {
        window.location = '/museum';
    },

    goToNewExhibition: function() {
        window.location = '/home';
    },

    hide: function() {
        this.exhibitionForm.visible = false;
    },

    save: function(exhibition) {
        Bus.publish('exhibition.save', exhibition.detail);
        this.goToForm();
    },

    goToForm: function() {
        urlLocation = window.location.pathname;
        isInRoot = ( urlLocation == '/' );
        isInHome = ( urlLocation == '/home' );
        if (!isInHome && !isInRoot){
            this.goToExhibitionId();
        }
    },

    goToExhibitionId: function() {
            var exhibitionId = this.loadShortUrlData(3);
            window.location = '/exhibition/' + exhibitionId + '/info';
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
        this.exhibitionForm.general_description = exhibition.general_description;
        this.exhibitionForm.typeValue = exhibition.type;
        this.exhibitionForm.date_start = exhibition.date_start;
        this.exhibitionForm.date_finish = exhibition.date_finish;
        if ( typeof (exhibition.translations) != "undefined" ) {
            this.fillLanguages(exhibition.translations);
        }
        this.showForm();
    },

    fillLanguages: function(translations) {
        for (var i=0; i<translations.length; i++) {
            switch (translations[i].iso_code) {
                case 'es':
                    this.fillSpanish(translations[i]);
                    break;
                case 'en':
                    this.fillEnglish(translations[i]);
                    break;
                case 'cat':
                    this.fillCatala(translations[i]);
                    break;
            }
        }
    },

    fillSpanish: function(language) {
        var spanish = document.getElementById('spanish');
        spanish.translation = language;
    },

    fillEnglish: function(language) {
        document.getElementById('languages').english = true;
        document.getElementsByClassName('english')[0].checked = true;
        var english = document.getElementById('english');
        english.visiblelang = 'true';
        english.toggleVisibility();
        english.translation = language;
    },

    fillCatala: function(language) {
        document.getElementById('languages').catala = true;
        document.getElementsByClassName('catala')[0].checked = true;
        var catala = document.getElementById('catala');
        catala.visiblelang = 'true';
        catala.toggleVisibility();
        catala.translation = language;
    },

    isEditable: function() {
        var url = window.location.href;
        return url.indexOf('edit') >= 0;
    },

    loadEditInfo: function() {
        urlLocation = window.location.pathname;
        isInRoot = ( urlLocation == '/' );
        isInHome = ( urlLocation == '/home' );
        if (!isInHome){
            if (!isInRoot){
                this.retrieveIfIsEditable();
            }
        }
    },

    retrieveIfIsEditable: function() {
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
        var regexp = /\/(exhibition)(\/)(.*)(\/)(edit)/;
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
