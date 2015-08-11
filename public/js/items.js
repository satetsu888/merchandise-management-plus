$.jsonRPC.setup({
    endPoint: 'jsonrpc',
});

var sortableList = function(){
    $("#itemList").sortable();
}

var getItems = function(vm){
    $.jsonRPC.request('getItems',{
        params: {},
        success: function(res){
            vm.items = res.result.items.concat();
            Vue.nextTick( sortableList );
        },
        error: function(res){
            console.log(res);
        }
    });
}

var setItem = function(item){
    $.jsonRPC.request('setItem',{
        params: { data: item },
        success: function(res){
            console.log(res);
        },
        error: function(res){
            console.log(res);
        }
    });
}

var vm = new Vue({
    el: '#itemListWrapper',
    data: {
        items : [],
    },
    ready: function(){
        var self = this;
        getItems(self);
    },
    methods: {
        updateItem: function(e){
            setItem(e.targetVM.$data);
        },
    }
});

