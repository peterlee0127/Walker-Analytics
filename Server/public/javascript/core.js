angular.module('Safe-Walker', [])
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
					/*
					var placeArr = [];
					var coordinateArr = [];
					$.each(data, function( i, raw ) {
						var addr = [];
						addr.push(raw.latitude);
						addr.push(raw.longitude);
						coordinateArr.push(addr);

						var place = { "text":raw.time+" "+raw.activity+" hor:"+raw.horizontalAccuracy,
													"addr": addr,
												  "id":raw._id };
						placeArr.push(place);
					});
					*/
					var circleArr = [];
					$.each(data,function(i,raw){
							var circle = {};
							circle.center = {   lat:raw.latitude,lng:raw.longitude  };
							circle.radius = raw.horizontalAccuracy;
							circle.width = 1;
							circle.color = '#333333';
							circle.fillcolor = '#999999';
							circle.id = raw._id;
							circleArr.push(circle);
					});

					/*
						 	function () {
                var i = 0,
                    icon = {},
                    pos = {},
                    distance = [],
                    nearest = false,
                    // 取得目前位置的 LatLng 物件
                    now = new google.maps.LatLng(current[0], current[1]),
                    // 取得 instance
                    m = map.data('tinyMap'),
                    // 取得已建立的標記
                    markers = m._markers;

                // 使用迴圈比對標記（忽略最末個）
                for (i; i < loc.length - 1; i += 1) {
                    // 建立標記的 LatLng 物件
                    pos = new google.maps.LatLng(loc[i].addr[0], loc[i].addr[1]);
                     // 利用幾何圖形庫比對標記與目前位置的測地線直線距離並存入陣列。
                     // http://goo.gl/ncP2Gz
										 distance.push(google.maps.geometry.spherical.computeDistanceBetween(pos, now));
                }
                //console.dir(distance);
                // 尋找陣列中最小值的索引值
                nearest = distance.indexOf(Math.min.apply(Math, distance));
                if (false !== nearest) {
                    if (undefined !== markers[nearest].infoWindow) {
                        // 開啟此標記的 infoWindow
                        markers[nearest].infoWindow.open(m.map, markers[nearest]);
                        // 更換此標記的圖示
                        markers[nearest].setIcon('http://app.essoduke.org/tinyMap/6.png');
                        markers[nearest].infoWindow.content += '<p>距離: ' + distance[nearest].toString() + ' 公尺</p>';
                        // 移動此標記至地圖中心
                        m.map.panTo(markers[nearest].position);
                    }
                }
            },
            'once': true
        }
					*/

				$('#map').tinyMap({ // 25.175654, 121.449588
								center: {x: '25.175654', y: '121.449588'},
								zoom: 16,
								// marker: placeArr,
								// markerFitBounds: true,
								// markerCluster: false,
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
