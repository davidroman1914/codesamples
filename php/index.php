<?php


	define('COLLECTION', 'userdata');

	define('BRANDNOTSELECTED', '[Brand] is missing the request data object.');


	class objectifyArray{ //cast convert array to object.
		//This way we are working with objects and not mixin data types.

		static function data( $arrayData ){
			return (object) $arrayData;
		}

	} 


	interface connectionActions {
		/*more methods should be added below. 
		For now all connection must have a separate functions, calling the DB and also to a Collection.*/

		public function selectDatabase( $_database_name );

		public function selectCollection( $_collection_name );

	}

	class mongoConnection implements connectionActions {

		/* Simple class doing setting and getting. 
		Incase logic needs to be modify you could create more methods.
		In a sort time some of these methods will become [final]. 
		So it's best to add your own methods.
		For now, you'll have access to the main connection or the collection.
		*/

		public $connection = NULL;

		public $collection = NULL;

		public $mongoClient = NULL;


		public function __construct(){

			$this->mongoClient = new MongoClient( );

			return $this;

		}

		public function selectDatabase( $_database_name ){

			$this->connection = $this->mongoClient->selectDB( $_database_name );
		}

		public function selectCollection( $_collection_name ){
				
			$this->collection = new MongoCollection($this->connection, $_collection_name); 
		}

		public function getConnetion( ){

			return $this->connection;
		}


		public function getCollection( ){

			return $this->collection;
		}


	}


	class mongoHelper extends mongoConnection {

		/*This Helper wrapper class helps with delegation of making the connection.
		Finding a user record.
		Inserting or updating which is common, in our logic scope. 
		 */

		public $mainConnection  = NULL;

		public function __construct(  ){

			$this->mainConnection = parent::__construct();

		}

		public function setSelectDatabase( $database ){
			$this->mainConnection->selectDatabase($database);
			return $this;

		}

		public function setSelectCollection( $collection ){
			$this->mainConnection->selectCollection( $collection );
			return $this;
		}


		public function findUser( array $array, $returnObj ){ // must be a array 

			$this->cursor =  $this->mainConnection->getCollection( )->findOne($array);

			if ($returnObj) {
				return objectifyArray::data( $this->cursor );
			}
			else{
				return $this;
			}

			
		}
		
		public function insert( stdClass $doc ){

			if (isset($this->cursor) && !empty($this->cursor) ) {
				//update only the game data object. 
				$this->cursor['gamedata'] = $doc->gamedata;
				$this->mainConnection->getCollection( )->save( $this->cursor );

				return (Object) $this->cursor;

			}

			else{
				//insert 
				return (Object) $this->mainConnection->getCollection( )->save( $doc );

			}


		}



	}


	class responseOut {

		/*This static class is to simply the response output to the browser. For now we use JSON.
		However, if we needed to introduce a XML response here it would be the best place to do it.*/

		static public function savedData( stdClass $obj ){
			echo json_encode( $obj );
		}

		static public function errorData( ){
			echo json_encode( array( 'message' =>  BRANDNOTSELECTED ) );
		}



	}


	interface ValidateData {

	
		/*
		When dealing with the request objects: GET | POST. We must make sure we 
		validate, if any error we provide error hinting. response to the client. 
		*/


		//When dealing with post | get data 

		public function readRequestType( $requestType ); //

		static public function errorHint();

		static public function output( $responseData );

		static public function init( $requestType );

	}


	class processRequest implements ValidateData {


		static function init( $requestType ){

			self::readRequestType( $requestType );
		}



		final public function readRequestType( $requestType ){/*
			Convert array to object, so we are working with the only data type [Object] for consistency. 
			Make sure we check for request type and also that we have the brand we are dealing with.

			If no brand just response back to the client with custom error.

			Otherwise lets connect to mongo by creating a instance of mongoHelper.
			MongoHelper is pretty much an adpater object, it will let us chain functionality. 


		*/

			$postobj = objectifyArray::data( $requestType );

			$userdata = new mongoHelper( );


			if (isset($requestType) && $requestType === $_POST && isset($postobj->brand) ) {
				//then request type is post 
					//time to write to Database.

					$responseData = $userdata->setSelectDatabase( $postobj->brand )
						->setSelectCollection(COLLECTION)
						->findUser(array('username' => $postobj->username ), false)
						->insert(
							$postobj
						);

					self::output( $responseData );

					$responseData = NULL;
					$postobj = NULL;
					$userdata = NULL;

			}

			elseif (isset($requestType) && $requestType === $_GET && isset($postobj->brand) ) {

					$responseData = $userdata->setSelectDatabase( $postobj->brand )
						->setSelectCollection(COLLECTION)
							->findUser(array('username' => $postobj->username), true);

				
					self::output( $responseData );

					$responseData = NULL;
					$postobj = NULL;
					$userdata = NULL;

			}

			else{

				self::errorHint( );
			}


		}

		static public function errorHint( ){

			responseOut::errorData( );	
		}


		static public function output( $responseData  ){

			responseOut::savedData( $responseData );

		}



	}


	processRequest::init( ( $_GET ) ? $_GET : $_POST );

	
