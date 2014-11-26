angular.module('Walker Analytics', [])
.controller('mainController', ['$scope','$http', function($scope,$http) {

	$scope.getRecord = function(){
		$http.get('/getAllList')
			.success(function(data) {
				$scope.MotionData = data;
			})
			.error(function(data) {
				console.log('Error: ' + data);
		});
	};
	function drawMapLine() {
		// top 				25.177124, 121.444276
		// down 			25.172374, 121.447352
		// right down 25.173899, 121.457147
		var polyLineArr = [];
		var longitude = [121.444,121.457];
		var latitude = [25.172,25.179];
		var width = 0.0005;
		var NumOfLongLine = (latitude[1]-latitude[0])/width+1;
		var NumOfLatLine =  (longitude[1]-longitude[0])/width+1;
		for(i=0;i<=NumOfLatLine;i++) {
						var num = longitude[0]+i*width;
						var dict = {};  var coords = [];
						coords.push([latitude[0],num]);
						coords.push([latitude[1],num]);
						dict.coords = coords;
						dict.color='#FFFF00';
						dict.width=1;
						polyLineArr.push(dict);     	}
		for(i=0;i<=NumOfLongLine;i++) {
						var num = latitude[0]+i*width;
						var dict = {};  var coords = [];
						coords.push([num,longitude[0]]);
						coords.push([num,longitude[1]]);
						dict.coords = coords;
						dict.color='#FFFF00';
						dict.width=1;
						polyLineArr.push(dict);         }
		return polyLineArr;
	}

	$scope.getList = function(){
		$http.get('/getAllList')
			.success(function(data) {
				data.sort(function(a,b){
					  var keyA = new Date(a.time),
				    keyB = new Date(b.time);
				    // Compare the 2 dates
				    if(keyA < keyB) return -1;
				    if(keyA > keyB) return 1;
    				return 0;
				});
				$scope.MotionData = data;

				var circleArr = [];
				$.each(data,function(index,raw){
						var color = '#'+Math.floor(Math.random()*16777215).toString(16);
						for(var i=0;i<raw.latitude.length;i++) {
								var circle = {};
								circle.center = {   lat:raw.latitude[i],lng:raw.longitude[i]  };
								circle.radius = raw.horizontalAccuracy;
								circle.width = 1;
								circle.color = color;
								circle.fillcolor = color;
								circle.id = raw._id+i;
								circleArr.push(circle);
						}
				});
				$('#map').tinyMap({ // 25.175654, 121.449588
								center: {x: '25.175654', y: '121.449588'},
								zoom: 17,
								circle: circleArr,
								streetViewControl:true,
								mapTypeControl:true,
								scaleControl:true
				});

			})
			.error(function(data) {
				console.log('Error: ' + data);
			});
  };

	$scope.getAnalytics = function(){
		$http.get('/getAllList')
			.success(function(data) {
				data.sort(function(a,b){
						var keyA = new Date(a.time),
						keyB = new Date(b.time);
						// Compare the 2 dates
						if(keyA < keyB) return -1;
						if(keyA > keyB) return 1;
						return 0;
				});
				$scope.MotionData = data;
				
					var circleArr = [];
					$.each(data,function(index,raw){
						var color = '#'+Math.floor(Math.random()*16777215).toString(16);
						for(var i=0;i<raw.latitude.length;i++) {
								var circle = {};
								circle.center = {   lat:raw.latitude[i],lng:raw.longitude[i]  };
								circle.radius = raw.horizontalAccuracy;
								circle.width = 1;
								circle.color = color;
								circle.fillcolor = color;
								circle.id = raw._id+i;
								circleArr.push(circle);
						}
					});
				$('#map').tinyMap({ // 25.175654, 121.449588
								center: {x: '25.175654', y: '121.449588'},
								zoom: 15,
								polyline:drawMapLine(),
								circle: circleArr,
								streetViewControl:true,
								mapTypeControl:true,
								scaleControl:true
				});

			})
			.error(function(data) {
				console.log('Error: ' + data);
			});
    	};

		$scope.deleteData = function(_id){
		var post = {  "_id":_id };
		$http.post('/api/deleteData/' , JSON.stringify(post))
			.success(function(data) {
				if(data=="ok"){
						$scope.getList();
				}
			})
			.error(function(data) {
				console.log('Error: ' + data);
				$scope.getList();
			});
	}

}]);
