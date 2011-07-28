$().ready(function() {
    
    var nameModel = {
        element: function() {
            return $('#fullNameView')[0];
        },
        firstName: ko.observable('Axel'),
        lastName: ko.observable('Nitzschner')
    };
    
    nameModel.fullName = ko.dependentObservable(function() {
        return this.firstName() + ' ' + this.lastName();
    }, nameModel);
    
    
    var formModel = {
        element: function() {
            return $('#formView')[0];
        }
    };
    
    formModel.items = ko.observableArray([]);
    formModel.itemToAdd = ko.observable('');
    formModel.addItem = function (e) {
        if (formModel.itemToAdd() != "") {
            //for ajax loader
            formModel.items.push(formModel.itemToAdd());
            formModel.itemToAdd('');
        } else {
            //for manually passed in items
            //formModel.itemToAdd(formModel.multiSelectedOptionValues())
            formModel.items.push(formModel.multiSelectedOptionValues());
            formModel.multiSelectedOptionValues('');
            formModel.itemToAdd('');
        }
    };
    formModel.multiSelectedOptionValues = ko.observable("");
    formModel.getModus = ko.dependentObservable( function() {
        //console.log(formModel.multiSelectedOptionValues().length)
        return formModel.itemToAdd().length > 0 ? formModel.itemToAdd() : formModel.multiSelectedOptionValues();
    }, formModel)
    
    var tmplModel = {
        element: function() {
            return $('#templateView')[0];
        },
        name: ko.observable('Bert'),
        age: ko.observable(78),
        makeOlder: function() {
            this.age(this.age() + 1);   
        }       
    };
    
    ko.applyBindings(nameModel, nameModel.element());
    ko.applyBindings(formModel, formModel.element());
    ko.applyBindings(tmplModel, tmplModel.element());
    
    myApp = {};
    myApp.loadSystems = function() {
        $.ajax({
            url: base_url+'tests/index',
            dataType: 'json',
            success: function(json) {
                $.each(json.value, function(i, item) {
                    console.log(item)
                    formModel.addItem(formModel.itemToAdd(item));
                })
            },
            complete: function() {
                console.log('I\'m here')
                //$('#loader').attr('disabled', 'disabled');
            }
        })
    };
})

