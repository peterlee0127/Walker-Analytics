var mongoose = require('mongoose');

mongoose.connect('mongodb://localhost:27017/Walker-Analytics');

exports.MotionData = mongoose.model('RawData',{
	'algorithmVer': Number,
  'activity'	:String,
	'timestamp'	 :Number,
	'horizontalAccuracy' :Number,
	'altitudeLog'	:[],
	'altitude'	:[],
	'floorIsAscended':Number,
	'latitude'	:[],
	'longitude'	:[]
});

exports.removeAllData = function()	{
		this.MotionData.remove({}, function(err) {
	});
}
