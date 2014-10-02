angular.module('Safe-Walker', [])
.controller('mainController', ['$scope','$http', function($scope,$http) {

	$scope.getList = function(){
		$http.get('/getList')
			.success(function(data) {
				$scope.MotionData = data;
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
