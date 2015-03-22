define("index",["jquery","tmpl","request"],function(require,exports,module){
       
       var tmpl 			= require("tmpl");
       var request 		= require("request");
       var expandedAddress = {};
       var lastUpdate 		= -1;
       var selectedAddress = null;
       
       var systemInfoList 	= [];
       
       var refreshViewTree = function(cb){
       
       var jqxhr =
       $.get("/api/loadViewTree",{"lastupdate":lastUpdate},function(data){
             
             var data = JSON.parse(data).data;
             var json = null;
             
             if (data.code == 304) return;
             
             json = data.content;
             lastUpdate = data.lastUpdate;
             
             $("#viewtree article").html(viewObj2HTML(json));
             
             //监测单双击
             var TimeFn = null;
             $("li.viewnode").on("click",function(e){
                                 clearTimeout(TimeFn);
                                 
                                 var addressValue = $(this).attr("address");
                                 var thisValue = $(this);
                                 TimeFn = setTimeout(function(){
                                                     
                                                     if (thisValue.hasClass("selected")) {
                                                     thisValue.removeClass("selected");
                                                     selectedAddress = null;
                                                     }else{
                                                     $("li.viewnode.selected").removeClass("selected");
                                                     thisValue.addClass("selected");
                                                     selectedAddress = thisValue.attr("address");
                                                     }
                                                     
                                                     
                                                     $.get("/api/highlightView",{address:addressValue});
                                                     }
                                                     ,100);
                                 }).on("dblclick",function(){
                                       clearTimeout(TimeFn);
                                       
                                       var name=prompt("For example '0,0,120,120'","")
                                       if (name!=null && name!=""){
                                       $.ajax({
                                              url:"/api/moveview",
                                              type:"get",
                                              data:{'value':name,'address':$(this).attr("address")},
                                              dataType:"json",
                                              success:function(data){
                                              if(data.code==200){
                                              refreshViewTree();
                                              }
                                              },
                                              error:function(){
                                              alert("error")
                                              }
                                              })
                                       }
                                       });
             
             $("a.arrow").on("click",function(e){
                             $viewnode = $(this).parent();
                             if ($viewnode.hasClass("expanded")) {
                             $viewnode.removeClass("expanded");
                             delete(expandedAddress[$viewnode.attr("address")]);
                             }else{
                             $viewnode.addClass("expanded");
                             expandedAddress[$viewnode.attr("address")] = 1;
                             }
                             
                             e.stopPropagation();
                             });
             
             cb && cb();
             
             if (selectedAddress) {
             $("li.viewnode[address="+selectedAddress+"]").addClass("selected");
             };
             
             for(var address in expandedAddress){
             $("li.viewnode[address="+address+"]").addClass("expanded");
             }
             });
       
       jqxhr.done(function() {
                  setTimeout(refreshViewTree,100);
                  }).fail(function() {
                          setTimeout(refreshViewTree,100);
                          });
       };
       
       var viewObj2HTML = function(view){
       var HTML = tmpl("<li class=viewnode address=<%=view.address%> <%=view.frame?('frame=\"'+view.frame+'\"'):''%> <%=view.hidden != undefined?('ishidden=\"'+view.hidden*1+'\"'):''%>>"+
                       "<%if(view.subviews && view.subviews.length>0){%><a class=arrow></a><%}%>"+
                       "<a class=viewinfo href=javascript:void(0)>&lt;"+
                       "<span class=h1><%=view.className%></span>&nbsp;"+
                       "<%=view.frame?('<span class=h2>frame</span>=<span class=h3>&quot;'+view.frame+'&quot;</span>&nbsp;'):''%>"+
                       "<%=view.bounds?('<span class=h2>bounds</span>=<span class=h3>&quot;'+view.bounds+'&quot;</span>&nbsp;'):''%>"+
                       "<span class=h2>hidden</span>=<span class=h3>&quot;<%=view.hidden?'YES':'NO'%>&quot;</span>"+
                       "<%for(var key in view){if(key=='subviews'||key=='address'||key=='className'||key=='frame'||key=='bounds'||key=='hidden')continue;print('&nbsp;<span class=h2>'+key+'</span>=<span class=h3>&quot;'+view[key]+'&quot;</span>')}%>"+
                       "&gt;</a>"+
                       "</li>",{view:view});
       if(view.subviews){
       HTML += "<ol>";
       for(var i = view.subviews.length-1;i >=0 ;i--){
       HTML += viewObj2HTML(view.subviews[i]);
       }
       HTML += "</ol>";
       }
       return HTML;
       
       };
       
       
       var $memVal 		= $("#memoryvalue");
       var $cpuVal 		= $("#cpuvalue");
       var $memoryTimeLine = $("#memorytimeline");
       var $cpuTimeLine	= $("#cputimeline");
       var $logContent		= $("#logContent");
       
       var refreshSystemInfo = function(cb){
       
       var maxHeight 	= 100;
       var heightRate 	= 0.9;
       var blockWidth 	= 2;
       var blockMargin = 0;
       var blockCount 	= 10;
       
       var minMem,maxMem,minCPU,maxCPU;
       
       if (systemInfoList.length > 0) {
       
       minMem = maxMem = systemInfoList[0].memory;
       minCPU = maxCPU = systemInfoList[0].cpu;
       
       for(var i = 0; i<systemInfoList.length;i++){
       if(minMem > systemInfoList[i].memory) minMem = systemInfoList[i].memory;
       if(maxMem < systemInfoList[i].memory) maxMem = systemInfoList[i].memory;
       if(minCPU > systemInfoList[i].cpu) minCPU = systemInfoList[i].cpu;
       if(maxCPU < systemInfoList[i].cpu) maxCPU = systemInfoList[i].cpu;
       }
       };
       
       var memRate 	= maxHeight * heightRate / (maxMem - minMem);
       var cpuRate 	= maxHeight * heightRate / (maxCPU - minCPU);
       var baseHeight 	= maxHeight * (1 - heightRate) / 2;
       
       $memoryTimeLine.empty();
       $cpuTimeLine.empty();
       
       for(var i = 0; i<systemInfoList.length;i++){
       
       var l = (blockMargin + blockWidth) * i;
       var memh = (systemInfoList[i].memory - minMem) * memRate + baseHeight;
       var cpuh = (systemInfoList[i].cpu - minCPU) * cpuRate + baseHeight;
       
       $("<div/>").addClass("momentblock")
       .css({"left":l+"px","height":memh+"px","width":blockWidth+"px"})
       .appendTo($memoryTimeLine);
       
       $("<div/>").addClass("momentblock")
       .css({"left":l+"px","height":cpuh+"px","width":blockWidth+"px"})
       .appendTo($cpuTimeLine);
       }
       };
       
       /*
        var loadLog = function(cb){
        
        $.get("/api/loadLog",function(d){
        
        var data = JSON.parse(d).data;
        var content = data.content;
        
        if (data.code == 404) return;
        
        for(var i = 0; i < content.length; i++){
        
        var item = content[i];
        
        if (item.type == "userlog") {
        
        var date = new Date();
        date.setTime(date);
        var timeStr = date.toTimeString().split(" ")[0];
        
        var $item = $("<div class='cell'><span class='time'>"+timeStr+"</span></div>").appendTo($logContent);
        
        $("<span/>").text(item.content).appendTo($item);
        
        $logContent[0].scrollTop = $logContent[0].scrollHeight;
        
        }
        
        if (item.type == "systeminfo") {
        
        systemInfoList.push(item);
        
        $memVal.html((item.memory).toFixed(1)+"MB");
        $cpuVal.html((item.cpu).toFixed(1)+"%");
        
        if (systemInfoList.length > 3) {
        
        if (systemInfoList.length > 100) {
        
        systemInfoList = systemInfoList.slice(systemInfoList.length - 100);
        };
        
        refreshSystemInfo();
        
        };
        
        };
        
        };
        
        
        }).done(function() {
        setTimeout(loadLog,100);
        }).fail(function() {
        setTimeout(loadLog,100);
        });
        }
        */
       
       $(function(){
         
         refreshViewTree();
         loadLog();
         
         var shifting 	= false;
         var sPressing 	= false;
         
         window.onkeyup = function(e){
         
         if(e.keyCode == 16){
         shifting = false;
         }
         
         if(e.keyCode == 87){
         sPressing = false;
         }
         };
         
         window.onkeydown = function(e){
         
         if(e.keyCode == 16){
         
         shifting = true;
         return;
         }
         
         if(e.keyCode == 87){
         
         sPressing = true;
         return;
         }
         
         if((e.keyCode >= 37 && e.keyCode <= 40) || e.keyCode == 72){
         
         var selectedView = $("li.viewnode.selected");
         if (!selectedView.length) return;
         
         e.preventDefault();
         
         var offset = 1;
         if (shifting) offset = 10;
         
         var frame 			= selectedView.attr("frame").replace(/[{}]/g,"").replace(" ","").split(",");
         var x 				= frame[0] * 1;
         var y 				= frame[1] * 1;
         var w 				= frame[2] * 1;
         var h 				= frame[3] * 1;
         var hidden 			= selectedView.attr("ishidden") * 1;
         
         if (sPressing) {
         
         if (e.keyCode == 37)		w -= offset; 
         else if(e.keyCode == 38)	h -= offset;
         else if(e.keyCode == 39)	w += offset;
         else if(e.keyCode == 40)	h += offset;
         
         }else{
         
         if (e.keyCode == 37)		x -= offset;
         else if(e.keyCode == 38)	y -= offset;
         else if(e.keyCode == 39)	x += offset;
         else if(e.keyCode == 40)	y += offset;
         }
         
         if (e.keyCode==72) 				hidden = !hidden;
         
         var info 			= {};
         info.frame 	= "{{" + x + "," + y + "},{" + w + "," + h + "}}";
         info.hidden	= hidden;
         
         var params 			= {};
         params.address 		= selectedView.attr("address");
         params.info 		= JSON.stringify(info);
         
         
         request("/api/moveview",params,function(){
                 
                 window.needToRefresh = true;
                 
                 });
         
         selectedView.attr("frame",info.frame);
         selectedView.attr("ishidden",info.hidden * 1)
         
         // $.get("/api/moveView",{address:selectedView.attr("address"),x:x,y:y,w:w,h:h,hidden:sethidden},function(){
         // 	window.needToRefresh = true;
         // });
         
         return false;
         }
         };
         
         
         // setInterval(function(){
         // 	if (window.needToRefresh){
         // 		refreshViewTree();
         // 		window.needToRefresh = false;
         // 	}
         // },1000);
         
         // setInterval(function(){
         // 	window.needToRefresh = true;
         // },1500);
         
         });
       
       });