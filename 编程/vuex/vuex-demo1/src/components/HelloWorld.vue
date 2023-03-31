<template>
  <div id="app">
    <a-input placeholder="请输入任务" class="my_ipt" :value="inputValue" @change="handleChaneg" /> <!-- 动态绑定inputValue，绑定chang事件 -->
    <a-button type="primary" @click="addItemToList()">添加事项</a-button>

    <a-list bordered :dataSource="getInfoList" class="dt_list">  
      <a-list-item slot="renderItem" slot-scope="item">
        <!-- 复选框 -->
        <a-checkbox :checked="item.done" @change="(e)=>{changeStatus(e,item.id)}">{{ item.info }}</a-checkbox>  <!-- 动态绑定checked状态，绑定change事件，利用箭头函数传值 -->
        <!-- 删除链接 -->
        <a slot="actions" @click="deletByID(item.id)">删除</a>  <!-- 绑定删除事件 -->
      </a-list-item>

      <!-- footer区域 -->
      <div class="footer" slot="footer">
        <span>{{ undoneLength }}条剩余</span>
        <a-button-group>
          <a-button :type="viewKey === 'all' ? 'primary' : 'default'" @click="changeKey('all')">全部</a-button>
          <a-button :type="viewKey === 'undone' ? 'primary' : 'default'" @click="changeKey('undone')">未完成</a-button>
          <a-button :type="viewKey === 'done' ? 'primary' : 'default'" @click="changeKey('done')">已完成</a-button>   
		  <!-- 动态绑定的type属性里面可以使用三元表达式 -->
        </a-button-group>
        <a @click="clean">清除已完成</a>
      </div>
    </a-list>
  </div>
</template>
<script>
import { mapState,mapMutations,mapGetters } from 'vuex'   //引入mapState，获取state里的值

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
	  ...mapState(['list','count','inputValue','viewKey']),   //映射state里面的值，要啥映射啥
	  ...mapGetters(['undoneLength','doneList','undoneList','getInfoList']),
	  getList(){   //这里的实现还有另外一个方法，参考store/index.js里的getInfoList
	  		if (this.viewKey === "all"){
				return this.list
			}
			if (this.viewKey  === "undone"){
				return this.doneList
			}
			if (this.viewKey  === "done"){
				return this.undoneList
			}
			return this.list
	  }
  },
  methods:{
	  
	  ...mapMutations(['setInput','removeItem','modifyStatus','clearDone','modifyKey']),  //映射mutations里面的方法，要啥映射啥
	  handleChaneg(e){
		  // this.$store.commit("setInput",e.target.value)  //第一种调用方法
		  this.setInput(e.target.value)  //第二种调用方法
	  },
	  addItemToList(){
		  if(this.inputValue.trim().length <= 0){
			  return this.$message.warning('文本框内容不能为空')
		  }
		  this.$store.commit("addItem")
	  },
	  deletByID(id){
		  // console.log(id)
		  this.removeItem(id)   //根据传入的id，删除指定的内容，调用mutations里的方法
	  },
	  changeStatus(e,id){
		  // console.log(e.target.checked)   //被点击时的状态
		  // console.log(id)    //被点击的id
		  const param = {   //组装传参数据表
			  id:id,
			  status:e.target.checked
		  }
		  this.modifyStatus(param)  //调用mutation
	  },
	  clean(){
		  this.clearDone()   //调用mutation
	  },
	  changeKey(key){
		  // console.log(key)
		  this.modifyKey(key)
	  },
	
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
