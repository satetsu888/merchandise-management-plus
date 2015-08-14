$.jsonRPC.setup({
    endPoint: 'jsonrpc',
});

var setupSortableList = function(){
    $("#itemList").sortable();
}

var setUp = function(){
    setupSortableList();
}

var getItems = function(vm){
    $.jsonRPC.request('getItems',{
        params: {},
        success: function(res){
            vm.items = res.result.items.concat();
            Vue.nextTick( setUp );
        },
        error: function(res){
            console.log(res);
        }
    });
}

var setItem = function(vm){
    $.jsonRPC.request('setItem',{
        params: { data: vm.$data },
        success: function(res){
            vm.$data = res.result.item;
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
            setItem(e.targetVM);
        },
    },
    components: {
        itemComponent: {
            props: ['item'],
        },
    }
});

Vue.filter(
    'asBool', {
        read: function(integer){
            return integer ? true : false;
        },
        write: function(bool){
            return bool ? 1 : 0;
        }
    }
);

