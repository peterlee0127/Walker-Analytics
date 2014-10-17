var mongoose = require('mongoose');

mongoose.connect('mongodb://localhost:27017/SafeWalker');

exports.MotionData = mongoose.model('Admin',{
		'activity'	:String,
		'time'	 :String,
		'horizontalAccuracy' :Number,
		'altitudeLog'	:String,
		'altitude'	:Number,
		'heading'    :Number,
		'floorIsAscended':Number,
		'latitude'	:Number,
		'longitude' :Number
});

exports.removeAllData = function(){
		this.MotionData.remove({}, function(err) {
		});
}
