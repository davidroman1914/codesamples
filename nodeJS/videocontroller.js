var model = require('../models/videos.js'),
	meta = require( '../models/metadata.js');

exports.load = function( app, mysql ){

	function getVideosData(req, res, next){
		model.videosdata(mysql, function( results ){
			if( results.length !== 0 ){
	       		req.videos = results;
	       		next();
	       }
	  	});
	}

	function getVideoCategories(req, res, next){
		model.videocategories(mysql, function( results ){
			if( results.length !== 0 ){
	       		req.videocategories = results;
	       		next();
	       }
	  	});
	}

	function getmetadata( req,res, next ){
		meta.metadata( mysql, 'videos' , function( results){
		  req.pageTitle = results[0].title;
		  req.pageDesc = results[0].desc;
		  req.pageKeywords = results[0].keywords
		  next();

		});
	}

	function renderPage( req, res ){
		res.render('index', { 
			title : req.pageTitle ,
			description: req.pageDesc,
			keywords: req.pageKeywords,
			videos: req.videos, 
			categories: req.videocategories, 
			page : "videos",
			currentPage: "videos", 
			videoindex: null,
			angularCtrl : true 
		}); 
	}

	function renderSeoPage( req, res, next ){

		/*inside the controller determine what video to set, it's used for deep linking in the MVC url
		 such as /video/[seo url id]*/

		/* no model logic is found here, simply only basic controller logic to toggle between logic for deep linking or default 	page.
		*/

		var index = 0, found = false;

		for( x in req.videos )
			if ( req.videos[x].seo_url === req.params.video ) {
				index = x;
				found = true;
			}
			//end of for loop

		if (found) { // if we do the video id from the memcached object then allow the app to contine by rendering the page
			res.render('index', { 
				title : 'Video Library & Tutorials for Gel Jewelry | Gel-a-Peel',
				videos: req.videos,
				categories: req.videocategories, 
				page : "videos", 
				videoindex : index,
				angularCtrl : true 
			}); 
		}

		else{// no video id was found set the status in the main app to 404 and allow the app to continue into the error page 
			res.status(404); // set and update status.
			next(); // error to the application gracefully.
		}


	}


	//using basic regex since the pattern to our URL start with a lang key such as: /en-us/ | /es-mx/ | ru-ru
	//in the route object we must have 4 objects: main data, the categories assign per page, meta data for seo, and then template.
	app.get('/([\w\W]{2})\-?([\w\W]{2})/videos', getVideosData, getVideoCategories, getmetadata, renderPage );
	app.get('/([\w\W]{2})\-?([\w\W]{2})/videos/:video', getVideosData, getVideoCategories, getmetadata, renderSeoPage )


}