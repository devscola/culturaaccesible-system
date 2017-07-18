Class('Item.Form', {

    Extends: Component,

    initialize: function() {
        Item.Form.Super.call(this, 'formulary');
        this.alert = document.getElementById('alert');
        this.alert.addEventListener('disableFields', this.disableFields.bind(this));
        this.alert.addEventListener('uncheckRoom', this.uncheckRoom.bind(this));
        this.element.addEventListener('submitted', this.save.bind(this));
        this.element.addEventListener('roomAlert', this.showAlert.bind(this));
        this.itemForm = document.getElementById('formulary');
        this.retrieveAnExhibition();
    },

    showAlert: function() {
        this.alert.visibility = 'show';
    },

    show: function(event) {
        this.itemForm.item = event.detail;
        this.itemForm.formVisibility = 'show';
    },

    disableFields: function() {
        this.element.disableItemInput = true;
        this.emptyFields();
        this.element.parentClass = "exhibition";
    },

    emptyFields: function() {
        this.element.date = '';
        this.element.author = '';
    },

    uncheckRoom: function() {
        document.getElementsByClassName("room")[0].checked = false;
        this.element.disableItemInput = false;
        this.element.parentClass = this.itemParentClass();
    },

    itemParentClass: function(){
        return this.loadParentClass();
    },

    retrieveAnExhibition: function() {
        var parentId = this.loadParentId();
        var parentClass = this.loadParentClass();
        var exhibitionId = this.loadExhibitionId();
        if (parentClass == 'room') {
            this.retrieveAnExhibitionByRoom(parentId);
            this.element.disableCheckBox = true;
            this.retrieveAnRoomNextNumber(exhibitionId);
        } else if (parentClass == 'scene') {
            this.retrieveAnExhibitionByItem(parentId);
            this.retrieveAnSceneNextNumber(exhibitionId);
        } else if (parentClass == 'exhibition') {
            this.retrieveAnExhibitionById(parentId);
            this.retrieveAnExhibitionNextNumber(exhibitionId);
        }
    },

    loadExhibitionByChildren: function(children) {
      if(children.parent_class == 'room'){
        this.retrieveAnExhibitionByRoom(children.parent_id)
        return
      }
      var payload = { 'id': children.parent_id };
      Bus.publish('exhibition.retrieve', payload);
    },

    suggestNextNumber: function(nextNumber) {
        this.element.number = nextNumber;
    },

    retrieveAnExhibitionById: function(parentId) {
        var payload = { 'id': parentId };
        Bus.publish('exhibition.retrieve', payload);
    },

    retrieveAnExhibitionNextNumber: function(exhibitionId) {
      var payload = { 'exhibition_id': exhibitionId, 'ordinal': '0.0.0' };
      Bus.publish('next.number.retrieve', payload);
    },

    retrieveAnExhibitionByRoom: function(parentId) {
      var payload = { 'id': parentId };
      Bus.publish('room.retrieve', payload);
    },

    retrieveAnRoomNextNumber: function(exhibitionId) {
        var payload = { 'exhibition_id': exhibitionId, 'ordinal': '1.0.0' };
        Bus.publish('next.number.retrieve', payload);
    },

    retrieveAnExhibitionByItem: function(parentId) {
      var payload = { 'id': parentId };
      Bus.publish('item.retrieve', payload);
    },

    retrieveAnSceneNextNumber: function(exhibitionId) {
        var payload = { 'exhibition_id': exhibitionId, 'ordinal': '1.1.0' };
        Bus.publish('next.number.retrieve', payload);
    },

    loadExhibitionId: function() {
        var urlString = window.location.href;
        var regexp = /\/(exhibition)(\/)(.*)(\/)(exhibition|room|scene)(\/)(.*)(\/)(.*)/;
        var urlParentId = regexp.exec(urlString)[3];
        return urlParentId;
    },

    loadParentId: function() {
        var urlString = window.location.href;
        var regexp = /\/(exhibition)(\/)(.*)(\/)(exhibition|room|scene)(\/)(.*)(\/)(.*)/;
        var urlParentId = regexp.exec(urlString)[7];
        return urlParentId;
    },

    loadParentClass: function() {
        var urlString = window.location.href;
        var regexp = /\/(exhibition)(\/)(.*)(\/)(exhibition|room|scene)(\/)(.*)(\/)(.*)/;
        var urlParentType = regexp.exec(urlString)[5];
        return urlParentType;
    },

    renderExhibition: function(exhibition) {
        this.element.exhibition = exhibition;
        this.setInitialParentAttributes(exhibition);
    },

    setInitialParentAttributes: function(exhibition) {
        this.element.parentId = this.loadParentId();
        this.element.parentClass = this.itemParentClass();
    },

    save: function(item) {
      Bus.publish('item.save', item.detail);
    },

    subscribe: function() {
        Bus.subscribe('exhibition.retrieved', this.renderExhibition.bind(this));
        Bus.subscribe('item.edit', this.show.bind(this));
        Bus.subscribe('room.retrieved', this.loadExhibitionByChildren.bind(this));
        Bus.subscribe('item.retrieved', this.loadExhibitionByChildren.bind(this));
        Bus.subscribe('next.number.retrieved', this.suggestNextNumber.bind(this));
    }
});
