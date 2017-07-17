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
        if (this.isEditable()) {
          var itemId = parentId;
          if(this.loadType() == 'room') {
            this.retrieveRoomToLoadAnExhibition(itemId);
            var payload = { 'id': itemId };
            Bus.publish('room.retrieve.editable', payload);
          }
          if(this.loadType() == 'scene-in-room'){
              var payload = { 'id': itemId };
              Bus.publish('item.retrieve.editable', payload);
          }
          if(this.loadType() == 'scene'){
              this.retrieveItemToLoadAnExhibition(itemId);
              var payload = { 'id': itemId };
              Bus.publish('item.retrieve.editable', payload);
          }
          if(this.loadType() == 'subscene'){
              this.retrieveSubsceneToLoadAnExhibition(itemId);
              var payload = { 'id': itemId };
              Bus.publish('item.retrieve.editable', payload);
          }
        } else {
          if (parentClass == 'room') {
              this.retrieveRoomToLoadAnExhibition(parentId);
              this.element.disableCheckBox = true;
          } else if (parentClass == 'scene') {
              this.retrieveItemToLoadAnExhibition(parentId)
          } else if (parentClass == 'exhibition') {
              var payload = { 'id': parentId };
              Bus.publish('exhibition.retrieve', payload);
              var payload = { 'id': parentId, 'ordinal': '0.0.0' }
              Bus.publish('next.number.retrieve', payload);
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

    retrieveRoomToLoadAnExhibition: function(roomId) {
      var payload = { 'id': roomId };
      Bus.publish('room.retrieve', payload);
    },

    retrieveItemToLoadAnExhibition: function(parentId) {
      var payload = { 'id': parentId };
      Bus.publish('item.retrieve', payload);
    },

    loadParentId: function() {
        var urlString = window.location.href;
        var regexp = /[exhibition|room|scene]\/(.*)\/[/item]/;
        return regexp.exec(urlString)[1];
    },

    loadParentClass: function() {
        var urlString = window.location.href;
        var regexp = /(.*)\/(.*)\/(.*)\/[/item]/;
        var parentClass = regexp.exec(urlString)[2];
        if (this.isEditable()) {
          if (parentClass == 'room') {
            parentClass = 'exhibition'
          }
        }
        return parentClass;

    },

    loadType: function() {
        var urlString = window.location.href;
        var regexp = /(.*)\/(.*)\/(.*)\/[/item]/;
        var type = regexp.exec(urlString)[2];

        return type;

    },

    renderExhibition: function(exhibition) {
        this.element.exhibition = exhibition;
        this.setInitialParentAttributes(exhibition);
    },

    setInitialParentAttributes: function(exhibition) {
        if (this.isEditable()) {
          this.element.parentId = exhibition.id;
          if(this.loadParentClass() == 'subscene') {
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
