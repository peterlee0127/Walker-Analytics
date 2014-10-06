var mongoose = require('mongoose');

mongoose.connect('mongodb://localhost:27017/SafeWalker');

exports.MotionData = mongoose.model('Admin',{
		'activity'	:String,
		'time'	 :String,
		'horizontalAccuracy' :Number,
		'verticalAccuracy': Number,
		'altitudeLog'	:String,
		'altitude'	:Number,
		'steps' 		:Number,
		'floorsAscended':Number,
		'floorsDescended':Number,
		'latitude'	:Number,
		'longitude' :Number
});

exports.removeAllData = function(){
		this.MotionData.remove({}, function(err) {
		});
}
