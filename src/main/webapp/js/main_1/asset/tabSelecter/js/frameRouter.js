!(function(){
	function router(){
		this.register = function (name, callback) {
			var isFrame= window.top?true:false;
			if(isFrame){
				var station = window.top.station?window.top.station:window.top.station={};
				if(station[name]&&station[name].length>0){
					station[name].push(callback);
				}else{
					station[name] = [callback];
				}
			}else{
				return false;
			}
			return this;
		};
		this.call = function (name, data) {
			var isFrame= window.top?true:false;
			if(isFrame){
				var station = window.top.station?window.top.station:null,
					win = window;
				if(station){
					if(station[name]&&station[name].length>0){
						var len = station[name].length, list = station[name];
						while(len--){
							list[len](data,win);
						}
					}else{
						return false;
					}
				}else{
					window.top.station={}
					return false;
				}
				return this;
			}else{
				var station = window.station?window.station:null;
				if(station[name]&&station[name].length>0){
					var len = station[name].length, list = station[name];
					while(len--){
						list[len](data);
					}
				}else{
					window.station={};
					return false;
				}
				return this;
			}
		};
		return this;
	}
	window.frameRouter = new router();
})(window);


