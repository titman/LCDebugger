/* modjs v2.0
 * 1.加入loader功能，开发者无需手动添加script标签
 * 2.根路径在config中设置
 */
;(function(window){
	var module = {}, loadList = {};
	var define = function(id,dependencies,exports){
		if(typeof(id)==="function") return use(id);//如果前面两个都省略，则通过use转换成define(id,exports)
		if(id.push) return use(id,dependencies);//如果第一个是数组，则通过use转换成define(id,dependencies,exports)
		if(!exports){//如果只有两个参数，且第一个不是数组，则第一个为id，第二个为export，重置一下
			exports = dependencies;
			dependencies  = [];
		}else if(typeof(dependencies) === "string"){//看看第二个参数是否字符串，若是，则转换一下
			dependencies = [dependencies];
		}
		module[id] = {id:id,dependencies:dependencies,exports:null,factory:exports,isexcuted:false};
		debug(id+ " is initialized.");
		for(var i = 0;i<dependencies.length;i++) loadScript(dependencies[i]);
		excuteAllMod();
	}
	var loadScript = function(scriptName){
		if(scriptName in loadList) return false;
		var scriptNode = document.createElement("script");
		scriptNode.src = modjs.baseUrl + scriptName + ".js";
		scriptNode.async = true;
		document.getElementsByTagName("head")[0].appendChild(scriptNode);
		loadList[scriptName] = true;
	};
	var excuteMod = function(mod){
		if(mod.isexcuted || !checkLoaded(mod.dependencies)) return false;
		if(typeof(mod.factory)==="function"){
			var exportArg = mod.exports = {};
			var exportReturn = mod.factory.call(window,require,exportArg,mod) || {};
			clone(exportArg,exportReturn);
		}else{
			mod.exports = mod.factory;
		}
		mod.isexcuted = true;
		debug(mod.id+ " is excuted.");
		return true;
	}
	var excuteAllMod = function(){
		for(var m in module){
			if(excuteMod(module[m])){
				excuteAllMod();
				return true;
			}
		}
		return false;
	}
	var checkLoaded = function(requireList){
		if(requireList)
		for(var i=0;i<requireList.length;i++){
			if(!module[requireList[i]]||!module[requireList[i]].isexcuted) return false;
		}
		return true;
	}
	var clone = function(to,from){
		for(var o in from){
			to[o] = from[o];
		}
		return to;
	}
	var require = function(modName){
		//如果没有exports,则返回空
		return (module[modName] && module[modName].exports)?module[modName].exports:{};
	}
	var debug = function(){
		if(modjs.debug&&console&&console.log) console.log.apply(console,arguments);
	}
	var modjs = window.modjs = clone({debug:false,baseUrl:"js/",require:require,modules:module},window.modjs||{});
	window.use = function(dependencies,exports){
		return define("module_" + new Date().getTime(),dependencies,exports);
	};
	window.define =  modjs.define = define;
})(window);