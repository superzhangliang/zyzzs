/**
 * 工具类
 */
!(function(){
	window.utils = {
		/**
		 * 随机整数
		 * @param min
		 * @param max
		 * @returns {number}
		 */
		randomInt:function(min, max){
			var s = min || 0, e = max || 9999,
				start = Math.min(s, e), end = Math.max(s, e);
			return Math.floor(Math.random()*(end-start+1)+start);
		},
		/**
		 * 随机id值
		 * @returns {*|number}
		 */
		randomIdNumber: function(){
			return this.randomInt(1,9999);
		},
		/**
		 * 数组中删除某元素
		 * @param array
		 * @param value
		 * @returns {*}
		 */
		removeFromArray: function (array, value) {
			var idx = array.indexOf(value);
			if (idx !== -1) {
				array.splice(idx, 1);
			}
			return array;
		},
		/**
		 * 随机id值(时间+随机数)
		 * @returns {string}
		 */
		randomId: function () {
			return (new Date().getTime())+utils.randomIdNumber()+"";
		},
		/**
		 * 输出事件
		 */
		logTime:function(){
			console.log((new Date()).toLocaleDateString() + " " + (new Date()).toLocaleTimeString());
		},
		/**
		 * 获取当前时间
		 * @returns {number}
		 */
		getTime: function(){
			return (new Date()).getTime();
		}
	};
})(window);
