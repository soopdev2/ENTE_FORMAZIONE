define( [
	"../var/document",
	"../var/support"
  ], function( document, support ) {
  
  "use strict";
  
  ( function() {
	var input = document.createElement( "input" ),
	  select = document.createElement( "select" ),
	  opt = select.appendChild( document.createElement( "option" ) );
  
	input.type = "checkbox";
  
	// Support: Android <=4.3 only
	// Default value for a checkbox should be "on"
	support.checkOn = input.value !== "";
  
	// Support: IE <=11 only
	// Must access selectedIndex to make default options select
	support.optSelected = opt.selected;
  
	// Create a separate input element for radio value testing
	var radioInput = document.createElement( "input" );
	radioInput.value = "t";
	radioInput.type = "radio";
	support.radioValue = radioInput.value === "t";
  } )();
  
  return support;
  
  } );