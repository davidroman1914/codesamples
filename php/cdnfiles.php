<?php include_once("config.php");?>
<?php include_once("cloudfiles.php");?>
<?php

	interface observeCDN {
	 	function cloudAuthenticate( $user , $api_key );
	}

	class Authenticate implements observeCDN {
		public function cloudAuthenticate( $user , $api_key ){
		 	return new CF_Authentication( $user , $api_key );
		}	
	}



	interface observeContainer {
		 function AuthObject( $user , $api_key );		
		 function chooseContainer( $container_name );
	}

	class ArrayCloudBuilder implements observeContainer {
		
		public $authObj = NULL;	
		public $cloudAuth = NULL;
		public $cloudConn = NULL;
		public $arrObj =    NULL;
		public $getContainer = NULL;
		public $objects =  NULL;

		function __construct( $authObj ){
			$this->authObj = $authObj;
		}

		public function AuthObject( $user , $api_key ){
			 $this->cloudAuth = $this->authObj->cloudAuthenticate( $user , $api_key );
			 $this->cloudAuth->ssl_use_cabundle();
			 $this->cloudAuth->authenticate();
			return $this->cloudAuth;
		} 	
		
		public function cloudConnect(){
		   $this->cloudConn = new CF_Connection( $this->cloudAuth );
		   $this->cloudConn->ssl_use_cabundle();
		   return $this->cloudConn;
		}
		
		public function chooseContainer( $container_name ){
		 	 $list = $this->cloudConn->list_containers();
		
			if( array_search( $container_name , $list ) ){
				$key =  array_search( $container_name , $list );
				return $this->arrObj = $list[$key];
			}

		}
	
	    public function getContainer(){
		   $this->getContainer = $this->cloudConn->get_container( $this->arrObj );
		   $this->objects = $this->getContainer->list_objects(); 
		   return $this->getContainer;
		}

	}

	class CloudAPI{

		static function getallObjectsFrom( $container ){
			$array = new ArrayCloudBuilder( new Authenticate() );
        		$array->AuthObject( USER , API_KEY );
        		$array->cloudConnect();
        		$array->chooseContainer( $container ); 
        		return $array->getContainer();
		}

	}
?>