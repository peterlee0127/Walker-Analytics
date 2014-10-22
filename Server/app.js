var express = require('express');
var app = express();
var path = require('path');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');
var morgan = require('morgan');
var methodOverride = require('method-override');
var helmet = require('helmet');
var csrf    = require('csurf')
var fs = require('fs');

var model = require('./model/model.js');

// view engine setup
app.set('view engine', 'ejs');
app.use(bodyParser.urlencoded({ extended: false }))
app.use(bodyParser.json())
app.use(bodyParser.json({ type: 'application/vnd.api+json' }))
// app.use(morgan('dev'));
app.use(methodOverride());
app.use(express.static(path.join(__dirname, 'public/javascript')));

app.use(helmet.xssFilter());
app.use(helmet.xframe());
app.use(helmet.nosniff());
app.use(helmet.ienoopen());
app.use(helmet.nocache());
app.disable('x-powered-by');

// No need csrf
app.post('/saveMotionData',function(req,res){
			if(!req.body.time){
					return;
			}
			model.MotionData.create(
			{
				activity: req.body.activity,
				time: req.body.time,
				horizontalAccuracy:req.body.horizontalAccuracy,
				altitudeLog:req.body.altitudeLog,
				altitude:req.body.altitude,
				heading:req.body.heading,
				floorIsAscended:req.body.floorIsAscended,
				latitude: req.body.latitude,
				longitude: req.body.longitude
			},function(err,ser){
				if(err){
					console.log("save fail");
				}
				else{
					// console.log("save successful");
				}
				res.end("ok");
			});

});


app.get('/' ,function(req,res){
		res.render('all',{ title:"Walker Analytics"});
});


app.get('/analytics' ,function(req,res){
		res.render('analytics',{ title:"Walker Analytics - Analytics"});
});

app.get('/rawRecord' ,function(req,res){
		res.render('rawRecord',{ title:"Walker Analytics - Record"});
});


app.get('/getAllList',function(req,res){
	model.MotionData.find(function(err,data){
		if(err)
			 res.send(err);
 		else
		   res.json(data);
	});
});

app.post('/api/deleteData/', function(req, res) {
	model.MotionData.findOne( {  _id:req.body._id },function(err,data)
	{
			if(!data){
				res.end("ok");
				return;
			}
			data.remove();
			res.end("ok");
	});
});

app.get('/removeAllData',function(res,res){
	model.removeAllData();
	res.send("removeAllData");
});


exports.startServer=function()
{
	app.listen(8082, function(){
			console.log("Express server listening on port " + "8082");
	});
}
