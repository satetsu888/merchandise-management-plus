$.jsonRPC.setup({
    endPoint: 'jsonrpc',
});

var setupList = function(){

    $("#itemList").accordion({
        header: "> .item > .item-header",
        collapsible: true,
        active : false
    }).sortable();
}

var vm = new Vue({
    el: '#itemList',
    data: {
        items : [],
    },
    ready: function(){
        var self = this;
        $.jsonRPC.request('getItems',{
            params: {},
            success: function(res){
                self.items = res.result.items.concat();
                Vue.nextTick( setupList );
            },
            error: function(res){
                console.log(res);
            }
        });
    }
});

