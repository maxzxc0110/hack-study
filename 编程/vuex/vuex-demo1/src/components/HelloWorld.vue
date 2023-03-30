<template>
  <div id="app">
    <a-input placeholder="请输入任务" class="my_ipt" :value="inputValue" @change="handleChaneg" /> <!-- 动态绑定inputValue，绑定chang事件 -->
    <a-button type="primary" @click="addItemToList()">添加事项</a-button>

    <a-list bordered :dataSource="list" class="dt_list">
      <a-list-item slot="renderItem" slot-scope="item">
        <!-- 复选框 -->
        <a-checkbox>{{ item.info }}</a-checkbox>
        <!-- 删除链接 -->
        <a slot="actions">删除</a>
      </a-list-item>

      <!-- footer区域 -->
      <div class="footer" slot="footer">
        <span>0条剩余</span>
        <a-button-group>
          <a-button type="primary">全部</a-button>
          <a-button>未完成</a-button>
          <a-button>已完成</a-button>
        </a-button-group>
        <a>清除已完成</a>
      </div>
    </a-list>
  </div>
</template>
<script>
import { mapState,mapMutations } from 'vuex'   //引入mapState，获取state里的值

export default {
  name: "app",
  data() {
    return {
		// count: this.$store.state.count
    };
  },
  created(){
	  this.$store.dispatch('getList')  //调用actions里的方法
  },
  computed:{
	  ...mapState(['list','count','inputValue'])   //映射state里面的值，要啥映射啥
  },
  methods:{
	  ...mapMutations(['setInput']),  //映射mutations里面的方法，要啥映射啥
	  handleChaneg(e){
		  // this.$store.commit("setInput",e.target.value)  //第一种调用方法
		  this.setInput(e.target.value)  //第二种调用方法
	  },
	  addItemToList(){
		  if(this.inputValue.trim().length <= 0){
			  return this.$message.warning('文本框内容不能为空')
		  }
		  this.$store.commit("addItem")
	  }
  }
};
</script>
<style scoped>
#app {
  padding: 10px;
}
.my_ipt {
  width: 500px;
  margin-right: 10px;
}
.dt_list {
  width: 500px;
  margin-top: 10px;
}
.footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
</style>
