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
				console.log(data);

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
								polyline: [{
											coords: coordinateArr,
											color: '#008800',
											width: 2
								}],
								polygon: [{
												coords: [
												[25.05922799282222, 121.52348791503903],
												[25.05580687982226, 121.52331625366207],
												[25.05425179688806, 121.52795111083981],
												[25.05751744826025, 121.53378759765621],
												[25.064048489938642, 121.52915274047848],
												[25.05922799282222, 121.52348791503903]
										],
										color: '#000033',
										fillcolor: '#0000cc',
										width: 1
								}],
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
