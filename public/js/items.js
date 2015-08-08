$.jsonRPC.setup({
    endPoint: 'jsonrpc',
});

var sortableList = function(){
    $("#itemList").sortable();
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
                Vue.nextTick( sortableList );
            },
            error: function(res){
                console.log(res);
            }
        });
    }
});

