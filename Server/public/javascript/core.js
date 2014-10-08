angular.module('Safe-Walker', [])
.controller('mainController', ['$scope','$http', function($scope,$http) {

	$scope.getRecord = function(){
		$http.get('/getList')
			.success(function(data) {
				$scope.MotionData = data;
			})
			.error(function(data) {
				console.log('Error: ' + data);
		});
	};


	$scope.getList = function(){
		$http.get('/getList')
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

					var placeArr = [];
					var coordinateArr = [];
					$.each(data, function( i, raw ) {
						var addr = [];
						addr.push(raw.latitude);
						addr.push(raw.longitude);
						coordinateArr.push(addr);

						var place = { "text":raw.time+" "+raw.activity+" hor:"+raw.horizontalAccuracy,"addr": addr  };
						placeArr.push(place);
					});

				$('#map').tinyMap({ // 25.175654, 121.449588
								center: {x: '25.175654', y: '121.449588'},
								zoom: 5,
								marker: placeArr,
								/*
								polyline: [{
											coords: coordinateArr,
											color: '#008800',
											width: 2
								}],
								*/
								/*
								polygon: [{
												coords:coordinateArr,
										color: '#000033',
										fillcolor: '#0000cc',
										width: 1
								}],
								*/
								markerFitBounds: true,
								streetViewControl:true,
								mapTypeControl:true,
								scaleControl:true,
								markerCluster: true
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
				$scope.getList();
			})
			.error(function(data) {
				console.log('Error: ' + data);
				$scope.getList();
			});
	}

}]);
