(function($){

    $.fn.item = function(){
        var ti = $(this).tmplItem();
        var item = ti.data;
        return($.isFunction(item.reload) ? item.reload() : null);
    };

    $.fn.forItem = function(item){
        return this.filter(function(){
            var compare = $(this).tmplItem().data;
            if (item.eql && item.eql(compare) || item === compare)
                return true;
        });
    };

    $.fn.serializeForm = function(){
        var result = {};
        $.each($(this).find("input,textarea").serializeArray(), function(i, item){
            result[item.name] = item.value;
        });
        return result;
    };

})(jQuery);