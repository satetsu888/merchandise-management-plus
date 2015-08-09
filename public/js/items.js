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

var setItems = function(vm){
    $.jsonRPC.request('setItems',{
        params: { data: vm.items },
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
        updateItems: function(e){
            setItems(e.targetVM);
        },
    }
});

