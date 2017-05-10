Class('Exhibitions.Panel', {

    initialize: function() {
        this.element = document.getElementById('exhibition-panel');
        this.subscribe();
        this.hidePanel();
    },

    render: function(exhibition) {
        this.showPanel();
        this.element.append(this.createTitle(exhibition.title));
        this.element.append(this.createPanelItems('Location: ', exhibition.location));
        this.element.append(this.createPanelItems('General description: ', exhibition.short_description));
        this.element.append(this.createPanelItems('Type: ', exhibition.type));
        this.element.append(this.createPanelItems('From: ', exhibition.date_start));
        this.element.append(this.createPanelItems('To: ', exhibition.date_finish));
        this.element.append(this.createPanelItems('Beacon number: ', exhibition.beacon));
        this.element.append(this.createPanelItems('Extended description: ', exhibition.description));
        return false;
    },

    createTitle: function(title) {
        var container = document.createElement('div');
        container.className = 'panel-title'
        container.textContent = 'Title: ' + title;
        return container;
    },

    createPanelItems: function(caption, item){
        var container = document.createElement('div');
        container.textContent = caption + item;
        return container;
    },

    hidePanel: function() {
        this.element.style.display = 'none';
    },

    showPanel: function() {
        this.element.style.display = 'block';
    },

    subscribe: function() {
        Bus.subscribe('exhibition.submitted.retrieved', this.render.bind(this));
    }

});
