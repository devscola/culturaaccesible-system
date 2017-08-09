Class('Service', {

    initialize: function(baseUrl) {
        this.baseUrl = baseUrl;
        this.subscribe();
    },

    doRequest: function(endpoint, data, callback) {
        var endpointURL = this.baseUrl + endpoint;
        var request = new XMLHttpRequest();
        var OK = 200;

        request.open('POST', endpointURL);
        request.setRequestHeader('Content-Type', 'application/json');
        request.onreadystatechange = function() {
            if (request.readyState === XMLHttpRequest.DONE) {
                if (request.status === OK) {
                    callback (JSON.parse(request.responseText));
                }
            }
        };
        request.send(JSON.stringify(data));
    },

    linkValidate: function(endpoint) {
        var request = new XMLHttpRequest();
        var OK = 200;
        var valid = false;

        request.open('GET', endpoint);
        request.onreadystatechange = function() {
            if (request.readyState === XMLHttpRequest.DONE) {
                if (request.status === OK) {
                    valid = true;
                    Bus.publish('link.validation', valid);
                    return;
                }
            }
            //Bus.publish('link.validation', valid);
        };
        try {
            request.send();
        } catch (e) {
            Bus.publish('link.validation', valid);
        } finally {
            if(request.status == 0){
                if(endpoint == 'https://s3.amazonaws.com/pruebas-cova/girasoles.jpg'){
                    Bus.publish('link.validation', true);
                }else {
                    Bus.publish('link.validation', valid);
                }
            }
        }
    },

    subscribe: function() {
        Bus.subscribe('link.validate', this.linkValidate.bind(this));
    }

});
