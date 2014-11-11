var mongoose = require('mongoose');

mongoose.connect('mongodb://localhost:27017/SafeWalker-Test');

exports.MotionData = mongoose.model('Admin',{
		'activity'	:String,
		'timestamp'	 :Number,
		'horizontalAccuracy' :Number,
		'altitudeLog'	:[],
		'altitude'	:[],
		'floorIsAscended':Number,
		'latitude'	:[],
		'longitude'	:[]
});

exports.removeAllData = function(){
		this.MotionData.remove({}, function(err) {
		});
}
