(function(){
	'use strict';
	angular.module( 'GlobalServices' , [] )
		.factory( 'Search' , [ '$filter' , function( $filter ){

			var search = {}

			search.find = function( obj, searchable ){

				return $filter('filter')( obj , searchable );

			}

			return search;

		}])
		.filter('unsafe', function($sce) { return $sce.trustAsHtml; });

	angular.module( 'VideojsServices' , [] )

		.factory( 'videojs' , [ '$rootScope' , function( $rootScope ){

			var video = {}

			video.ready = function(_function){
				//will make sure, that the video object is ready on the page and is ready to accept functions.
				//this is also the wrapper api to delegate the state of the browser and videojs.

				angular.element(document).ready(function () { 
					_function();
				});

			}

			video.config = function(_elementID ,_config, _videopath ){

				video.ready( function(){

					$rootScope.videojs = videojs(_elementID, _config, function(){

		  					$rootScope.videojs = this;
		  					$rootScope.videopath = _videopath;
		  					$rootScope.videojs.volume(50); 

					});

					video.instance = $rootScope.videojs;
				});


			}


			video.loadvideo = function(_videofile){
				video.ready( function () {
					$rootScope.videosrc = video.videomediaobject(_videofile);
					$rootScope.videojs.pause();
				});

			}


			video.loadandplay = function(_videofile){

				video.ready( function () {

					video.videomediaobject(_videofile);
					$rootScope.videojs.play();
					
					//Show Big Button when video end
					$rootScope.videojs.on("ended", function(){
   						$rootScope.videojs.bigPlayButton.show();
  					});



				});


			}


			video.videomediaobject = function (_videofile){

					return  $rootScope.videosrc = $rootScope.videojs.src([
					{ type: "video/mp4",  src:  $rootScope.videopath + _videofile + ".mp4"  },
					{ type: "video/m4v",  src:  $rootScope.videopath + _videofile + ".m4v"  },
					{ type: "video/ogg",  src:  $rootScope.videopath + _videofile + ".ogv"  },
					{ type: "video/webm", src:  $rootScope.videopath + _videofile + ".webm"  }]
				);


			}



			return video;

		}])




		angular.module('AnalyticService', ['angular-google-analytics'])

		.config(function (AnalyticsProvider) {
  			// Add configuration code as desired - see below 

  			AnalyticsProvider.setAccount('UA-5522344-38');

  			AnalyticsProvider.useDisplayFeatures(true);

  			AnalyticsProvider.setDomainName('Gel-A-Peel');

  			AnalyticsProvider.trackPages(true);

  			AnalyticsProvider.logAllCalls(true); // for testing. 

		})

		.run(function(Analytics) { /* call anything at run time */ })

		.factory( 'analytics' , [ '$rootScope', 'Analytics' , function( $rootScope, Analytics ){ 

			return Analytics;

		}]);
		




})();