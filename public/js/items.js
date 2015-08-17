$.jsonRPC.setup({
    endPoint: 'jsonrpc',
});

var temporaryHand;

var setupSortableList = function(){
    $("#itemList").sortable();
    $("#itemList").sortable(
        "option", {
            axis : "y",
            opacity : 0.8
        }
    );
}

var setUp = function(){
    setupSortableList();
}

var getUser = function(vm){
    $.jsonRPC.request('getUser',{
        params: {},
        success: function(res){
            vm.user = res.result.user;
        },
        error: function(res){
            console.log(res);
        }
    });
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
    el: '#app',
    data: {
        user  : {},
        items : [],
    },
    ready: function(){
        var self = this;
        getItems(self);
        getUser(self);
    },
    methods: {
        updateItem: function(e){
            setItem(e.targetVM);
        },
        grabVariations: function(e){
            var variations = e.targetVM.$data.variations;
            temporaryHand = variations.map(
                function(current, index, array){
                    current.variation_id = "";
                    return current;
                }
            );
        },
        setVariations: function(e){
            var current = e.targetVM.$data.variations;
            var currentVariations = current.map(function(c,i,a){return c.variation});
            var newVariations = $(temporaryHand).not(function(index){
                var result = $.inArray(this.variation, currentVariations);
                return result == -1 ? false : true;
            }).get();

            e.targetVM.$data.variations = current.concat( newVariations );
        }
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

