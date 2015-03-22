define("request","jquery",function(require,exports,module){

	var taskList = {};

	var startReuqest = function(url){

		if (taskList[url].length > 0) {

			var info = taskList[url][0];

			$.get(info.url,info.params,info.cb)
			 .always(function(){

			 	taskList[url] = taskList[url].slice(1);
			 	startReuqest(url);

			 });
		};

	};

	module.exports = function(url,params,cb){

		if (!taskList[url]) {
			taskList[url] = [];
		};

		taskList[url].push({url:url,params:params,cb:cb});

		if (taskList[url].length == 1) {

			startReuqest(url);
		};
	};

});