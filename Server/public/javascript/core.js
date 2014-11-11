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
		var polyLineArr = [];
		var longitude = 119;
		for(i=0;i<=10000;i++) {
						var num = longitude+i*0.0005;
						var dict = {};
						var coords = [];
						coords.push([21,num]);
						coords.push([26,num]);
						dict.coords = coords;
						dict.color='#008800';
						dict.width=1;
						polyLineArr.push(dict);
		}
		var latitude = 21;
		for(i=0;i<=10000;i++) {
						var num = latitude+i*0.0005;
						var dict = {};
						var coords = [];
						coords.push([num,119]);
						coords.push([num,123]);
						dict.coords = coords;
						dict.color='#008800';
						dict.width=1;
						polyLineArr.push(dict);
		}
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
				$.each(data,function(i,raw){
						for(var i=0;i<raw.latitude.length;i++) {
								var circle = {};
								circle.center = {   lat:raw.latitude[i],lng:raw.longitude[i]  };
								circle.radius = raw.horizontalAccuracy;
								circle.width = 1;
								circle.color = '#dc143c';
								circle.fillcolor = '#dc143c';
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
					$.each(data,function(i,raw){
						  for(var i=0;i<raw.latitude.length;i++) {
									var circle = {};
									circle.center = {   lat:raw.latitude[i],lng:raw.longitude[i]  };
									circle.radius = raw.horizontalAccuracy;
									circle.width = 1;
									circle.color = '#dc143c';
									circle.fillcolor = '#dc143c';
									circle.id = raw._id+i;
									circleArr.push(circle);
							}
					});
				$('#map').tinyMap({ // 25.175654, 121.449588
								center: {x: '25.175654', y: '121.449588'},
								zoom: 17,
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
