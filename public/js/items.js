$.jsonRPC.setup({
    endPoint: 'jsonrpc',
});

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
            },
            error: function(res){
                console.log(res);
            }
        });
    }
});
