Class('Item.Form', {

    Extends: Component,

    initialize: function() {
        Item.Form.Super.call(this, 'formulary');
        this.alert = document.getElementById('alert');
        this.alert.addEventListener('disableFields', this.disableFields.bind(this));
        this.alert.addEventListener('uncheckRoom', this.uncheckRoom.bind(this));
        this.element.addEventListener('submitted', this.save.bind(this));
        this.element.addEventListener('roomAlert', this.showAlert.bind(this));
        this.element.disableSaveButton = true;
        this.itemForm = document.getElementById('formulary');
        this.loadFormInfo();
    },

    save: function(item) {
        if (item.detail.id == '') {
            Bus.publish('item.save', item.detail);
        } else {
            Bus.publish('item.update', item.detail);
        }
    },

    editRoom: function(room) {
        if (this.isEditable() && room.type == 'room') {
            this.element.name = room.name;
            this.element.number = room.number;
            this.element.description = room.description;
            this.element.beacon = room.beacon;
            document.getElementsByClassName("room")[0].checked = true;
            this.element.room = true;
            this.element.lastNumber = room.number;
            this.element.disableSaveButton = false;
            this.element.editId = room.id;
            this.element.disableCheckBox = true;
            this.element.type = room.type;
            this.disableFields();
        }
    },

    editScene: function(scene) {
        if (this.isEditable() && scene.type == 'scene') {
            this.element.name = scene.name;
            this.element.number = scene.number;
            this.element.author = scene.author;
            this.element.date = scene.date;
            this.element.description = scene.description;
            this.element.beacon = scene.beacon;
            document.getElementsByClassName("room")[0].checked = false;
            this.element.room = false;
            this.element.lastNumber = scene.number;
            this.element.disableSaveButton = false;
            this.element.editId = scene.id ;
            this.element.disableCheckBox = true;
            this.element.type = scene.type;
        }
    },

    loadFormInfo: function() {
        var parentId = this.getParentId();
        var parentClass = this.getParentClass();
        var exhibitionId = this.getExhibitionId();
        this.retrieveExhibition(exhibitionId);
        if (this.isEditable()) {
            this.loadEditables(parentClass, parentId);
        } else if (parentClass == 'room') {
            this.element.disableCheckBox = true;
            this.retrieveNextNumber(exhibitionId, parentClass, parentId);
        } else {
            this.retrieveNextNumber(exhibitionId, parentClass, parentId);
        }
    },

    retrieveExhibition: function(id) {
        var payload = { 'id': id };
        Bus.publish('exhibition.retrieve', payload);
    },

    loadEditables: function(parentClass, parentId) {
        var exhibitionId = this.getExhibitionId()
        if(parentClass == 'scene' ) {
            var payload = { 'id': parentId, 'exhibition_id': exhibitionId };
            Bus.publish('item.retrieve.editable', payload);
        } else{
            var payload = { 'id': parentId, 'exhibition_id': exhibitionId };
            Bus.publish('room.retrieve.editable', payload);
        }
    },

    retrieveNextNumber: function(exhibitionId, parentClass, parentId) {
      var payload = { 'exhibition_id': exhibitionId, 'parent_class': parentClass, 'parent_id': parentId };
      Bus.publish('next.number.retrieve', payload);
    },


    loadUrlData: function(index) {
        var urlString = window.location.href;
        var regexp = /\/(exhibition)(\/)(.*)(\/)(exhibition|room|scene)(\/)(.*)(\/)(.*)/;
        var data = regexp.exec(urlString)[index];
        return data;
    },

    getExhibitionId: function() {
      return this.loadUrlData(3);
    },

    getParentClass: function() {
      return this.loadUrlData(5);
    },

    getParentId: function() {
      return this.loadUrlData(7);
    },

    isEditable: function() {
        var url = window.location.href;
        return url.indexOf('edit') >= 0;
    },

    suggestNextNumber: function(nextNumber) {
        this.element.number = nextNumber;
    },

    renderExhibition: function(exhibition) {
        this.element.exhibition = exhibition;
        this.setInitialParentAttributes(exhibition);
    },

    setInitialParentAttributes: function(exhibition) {
        if (this.isEditable()) {
            this.element.parentId = exhibition.id;
            if(this.loadUrlData(5) == 'scene') {
                this.retrieveSubsceneParentId();
            }
        } else {
            this.element.parentId = this.loadUrlData(7);
        }
        this.setParentClass();
    },

    retrieveSubsceneParentId: function() {
        var id = this.loadUrlData(7)
        var exhibitionId = this.getExhibitionId()
        var payload = { 'id': id, 'exhibition_id': exhibitionId};
        Bus.publish('subscene.scene.retrieve', payload)
    },

    setSubsceneParentId: function(scene) {
        this.element.parentId = scene.parent_id;
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
        this.setParentClass();
    },

    emptyFields: function() {
        this.element.date = '';
        this.element.author = '';
    },

    uncheckRoom: function() {
        document.getElementsByClassName("room")[0].checked = false;
        this.element.disableItemInput = false;
        this.setParentClass();
    },

    setParentClass: function(){
        this.element.parentClass = this.loadUrlData(5);
    },

    subscribe: function() {
        Bus.subscribe('exhibition.retrieved', this.renderExhibition.bind(this));
        Bus.subscribe('item.edit', this.show.bind(this));
        Bus.subscribe('subscene.scene.retrieved', this.setSubsceneParentId.bind(this));
        Bus.subscribe('scene.retrieved.editable', this.editScene.bind(this));
        Bus.subscribe('room.retrieved.editable', this.editRoom.bind(this));
        Bus.subscribe('next.number.retrieved', this.suggestNextNumber.bind(this));
    }
});
