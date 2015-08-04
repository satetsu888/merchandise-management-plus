$.jsonRPC.setup({
    endPoint: 'jsonrpc',
});

new Vue({
    el: '.items',
    ready: function(){
        $.jsonRPC.request('getItems',{
            params: {},
            success: function(result){
                this.$data = result;
            },
            error: function(result){
                console.log(result);
            }
        })
    }
});
