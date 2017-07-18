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

        if (this.isEditable()) {
          var itemId = parentId;
          if(parentClass == 'exhibition') {
            this.retrieveRoomToLoadAnExhibition(itemId);
            var payload = { 'id': itemId };
            Bus.publish('room.retrieve.editable', payload);
          } else if(parentClass == 'room'){
              var payload = { 'id': itemId };
              Bus.publish('item.retrieve.editable', payload);
          } else if(parentClass == 'scene'){
              this.retrieveItemToLoadAnExhibition(itemId);
              var payload = { 'id': itemId };
              Bus.publish('item.retrieve.editable', payload);
          } else {
              this.retrieveSubsceneToLoadAnExhibition(itemId);
              var payload = { 'id': itemId };
              Bus.publish('item.retrieve.editable', payload);
          }
        } else {

          if (parentClass == 'room') {
              this.retrieveAnExhibitionByRoom(parentId);
              this.element.disableCheckBox = true;
              this.retrieveAnRoomNextNumber(exhibitionId);
          } else if (parentClass == 'scene') {
              this.retrieveRoomToLoadAnExhibition(parentId);
              this.retrieveAnSceneNextNumber(exhibitionId);
          } else if (parentClass == 'exhibition') {
              this.retrieveAnExhibitionById(parentId);
              this.retrieveAnExhibitionNextNumber(exhibitionId);
          }
        }
    },

    isEditable: function() {
      var url = window.location.href;
      return url.indexOf('edit') >= 0;
    },

    retrieveSubsceneToLoadAnExhibition: function(subsceneId) {
      var payload = { 'id': subsceneId };
      Bus.publish('subscene.retrieve', payload);
    },

    loadExhibitionByChildren: function(item) {
      if(item.parent_class == 'room' ){
        this.retrieveRoomToLoadAnExhibition(item.parent_id)
        return
      } else if(item.parent_class == 'scene' ){
        this.retrieveItemToLoadAnExhibition(item.parent_id)
        return
      }
      var payload = { 'id': item.parent_id };
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

    retrieveRoomToLoadAnExhibition: function(roomId) {
      var payload = { 'id': roomId };
      Bus.publish('room.retrieve', payload);
    },

    retrieveItemToLoadAnExhibition: function(parentId) {
      var payload = { 'id': parentId };
      Bus.publish('item.retrieve', payload);
    },

    retrieveAnSceneNextNumber: function(exhibitionId) {
        var payload = { 'exhibition_id': exhibitionId, 'ordinal': '1.1.0' };
        Bus.publish('next.number.retrieve', payload);
    },

    loadExhibitionId: function() {
        var urlString = window.location.href;
        var regexp = /\/(exhibition)(\/)(.*)(\/)(exhibition|room|scene|subscene)(\/)(.*)(\/)(.*)/;
        var urlParentId = regexp.exec(urlString)[3];
        return urlParentId;
    },

    loadParentId: function() {
        var urlString = window.location.href;
        var regexp = /\/(exhibition)(\/)(.*)(\/)(exhibition|room|scene|subscene)(\/)(.*)(\/)(.*)/;
        var urlParentId = regexp.exec(urlString)[7];
        return urlParentId;
    },

    loadParentClass: function() {
        var urlString = window.location.href;
        var regexp = /\/(exhibition)(\/)(.*)(\/)(exhibition|room|scene|subscene)(\/)(.*)(\/)(.*)/;
        var urlParentType = regexp.exec(urlString)[5];
        return urlParentType;
    },

    renderExhibition: function(exhibition) {
        this.element.exhibition = exhibition;
        this.setInitialParentAttributes(exhibition);
    },

    setInitialParentAttributes: function(exhibition) {
        if (this.isEditable()) {
          this.element.parentId = exhibition.id;
          if(this.loadParentClass() == 'scene') {
            var payload = { id: this.loadParentId() };
            Bus.publish('subscene.parentId.retrieve', payload)
          }
        } else {
          this.element.parentId = this.loadParentId();
        }
        this.element.parentClass = this.itemParentClass();
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

    setSubsceneParentId: function(subscene) {
        this.element.parentId = subscene.parent_id;
    },

    subscribe: function() {
        Bus.subscribe('exhibition.retrieved', this.renderExhibition.bind(this));
        Bus.subscribe('item.edit', this.show.bind(this));
        Bus.subscribe('room.retrieved', this.loadExhibitionByChildren.bind(this));
        Bus.subscribe('item.retrieved', this.loadExhibitionByChildren.bind(this));
        Bus.subscribe('subscene.parentId.retrieved', this.setSubsceneParentId.bind(this));
        Bus.subscribe('subscene.retrieved', this.loadExhibitionByChildren.bind(this));
        Bus.subscribe('scene.retrieved.editable', this.editScene.bind(this));
        Bus.subscribe('room.retrieved.editable', this.editRoom.bind(this));
        Bus.subscribe('next.number.retrieved', this.suggestNextNumber.bind(this));
    }
});
