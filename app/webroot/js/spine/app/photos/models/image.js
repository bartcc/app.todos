var Image = Spine.Model.setup("Image", ["name", "description", "exposure", "tags"]);

// Persist model between page reloads
Image.extend(Spine.Model.Ajax);
Image.extend(Spine.Model.Filter);

Image.extend({
    selectAttributes: ["name", "description", "exposure", "tags"],

    nameSort: function(a, b){ 
        if(a.name == b.name){
            if (a.name == b.name) return 0;
            return (a.name < b.name) ? -1 : 1;
        }

        return (a.name < b.name) ? -1 : 1;
    }
});

Image.include({
    selectAttributes: function(){
        var result = {};
        for (var i=0; i < this.parent.selectAttributes.length; i++) {
            var attr = this.parent.selectAttributes[i];
            result[attr] = this[attr];
        }
        return result;
    },
  
    fullName: function(){
        if ( !this.first_name && !this.last_name ) return;
        return(this.first_name + " " + this.last_name);
    }
});