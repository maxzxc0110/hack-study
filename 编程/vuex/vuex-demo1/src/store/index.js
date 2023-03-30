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
		nextID:5
	},
	getters: {},
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