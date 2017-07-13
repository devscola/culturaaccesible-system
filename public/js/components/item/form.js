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
          if(this.loadType() == 'room') {
            this.retrieveAnExhibitionByRoom(parentId);
            var payload = { 'id': parentId };
            Bus.publish('room.retrieve', payload);
          }
        } else {
          if (parentClass == 'room') {
              this.retrieveAnExhibitionByRoom(parentId);
              this.element.disableCheckBox = true;
          } else if (parentClass == 'scene') {
              this.retrieveAnExhibitionByItem(parentId)
          } else if (parentClass == 'exhibition') {
              var payload = { 'id': parentId };
              Bus.publish('exhibition.retrieve', payload);
          }
        };
    },

    isEditable: function() {
      var url = window.location.href;
      return url.indexOf('edit') >= 0;
    },

    loadExhibitionByChildren: function(children) {
      if(children.parent_class == 'room'){
        this.retrieveAnExhibitionByRoom(children.parent_id)
        return
      }
      var payload = { 'id': children.parent_id };
      Bus.publish('exhibition.retrieve', payload);
    },

    retrieveAnExhibitionByRoom: function(parentId) {
      var payload = { 'id': parentId };
      Bus.publish('room.retrieve', payload);
    },

    retrieveAnExhibitionByItem: function(parentId) {
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
      if (this.isEditable()) {
        this.element.name = room.name;
        this.element.number = room.number;
        this.element.description = room.description;
        this.element.beacon = room.beacon;
        document.getElementsByClassName("room")[0].checked = true;
        this.element.room = true;
        this.element.lastNumber = room.number;
        this.element.disableSaveButton = false;
        this.element.editId = room.id
        this.disableFields();
      }
    },

    subscribe: function() {
        Bus.subscribe('exhibition.retrieved', this.renderExhibition.bind(this));
        Bus.subscribe('item.edit', this.show.bind(this));
        Bus.subscribe('room.retrieved', this.loadExhibitionByChildren.bind(this));
        Bus.subscribe('item.retrieved', this.loadExhibitionByChildren.bind(this));
        Bus.subscribe('room.retrieved.editable', this.editRoom.bind(this));

    }
});
