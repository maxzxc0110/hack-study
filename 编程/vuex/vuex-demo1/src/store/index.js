import Vue from 'vue'
import Vuex from 'vuex'
import axios from 'axios'

Vue.use(Vuex)

export default new Vuex.Store({
	state: {
		//所有的任务列表
		list: [],
		count: 123,
		inputValue:"aaa",
		nextID:5,
		viewKey:"all"
	},
	getters: {
		undoneLength:state=>{   //定义一个undoneLength，统计未完成条数
			return state.list.filter(x => x.done === false).length
		},
		doneList:state=>{    //定义一个doneList，统计已完成
			return state.list.filter(x => x.done === false)
		},
		undoneList:state=>{ //定义一个undoneList，统计未完成
			return state.list.filter(x => x.done === true)
		},
		
		 //这里的实现还有另外一个方法，参考HelloWorld.ve里的getList
		getInfoList:state=>{  //直接在getters里定义一个获取当前状态的函数供页面端调用
			
			if (state.viewKey === 'all'){
				return state.list
			}
			
			if (state.viewKey === 'undone'){
				return state.list.filter(x => x.done === true)
			}
			
			if(state.viewKey === 'done'){
				return state.list.filter(x => x.done === false)
			}
		}
	},
	mutations: { //同步操作，只有mutations能修改state的值
		initList(state, list) {
			state.list = list
		},
		setInput(state,value){
			state.inputValue = value
		},
		addItem(state){
			const obj = {
				id:state.nextID,
				info:state.inputValue,
				done:false
			}
			state.list.push(obj)
			state.nextID++
			state.inputValue = ""
		},
		removeItem(state,id){
			const i = state.list.findIndex(x => x.id === id)  //查找对应ID的数组下标
			
			if(i !=-1){
				state.list.splice(i,1)  //删除列表里对应下标的数据，表示从下标i开始，删除1位数据
			}
		},
		modifyStatus(state,param){
			const i = state.list.findIndex(x =>x.id === param.id) //根据传入id找到下标
			if( i != -1){
				state.list[i].done = param.status  //修改状态值
			}
		},
		clearDone(state){
			state.list = state.list.filter(x =>x.done === false)  //查找所有未完成条目，重新赋值到list
		},
		modifyKey(state,key){
			state.viewKey = key
		}
	},
	actions: { //异步操作
		getList(context) { //初始化列表，打开页面的时候调用，第一个参数一定是context
			axios.get('/list.json').then(({data}) => { //使用axios拿到本地json文件的值,data里面存的就是json
				context.commit('initList', data) //commit调用mutations里的方法
			})
		}

	},
	modules: {}
})