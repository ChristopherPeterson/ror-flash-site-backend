// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
var obj;
var speed = 5;
var height = 0;

function showHome () {
  new Effect.Appear('notice', { duration: 0.5, queue: 'end' }); 
  noticeFadeHandle = new PeriodicalExecuter(function(pe) {
    new Effect.Fade('notice', { duration: 0.5}); 
    pe.stop();
  }, 7);
  
  return false;
};

Event.observe(window, 'resize', function(){
  height = Element.viewportOffset('copyright')[1] - Element.viewportOffset('content')[1];
  obj.style.top = 0 + "px";
  
  if (((obj.offsetHeight+obj.offsetTop) <= height) && (obj.offsetTop == 0)) {
    $('up').setStyle({
      display: 'none'
    });
    $('down').setStyle({
      display: 'none'
    });
  } else {
    $('up').setStyle({
      display: 'block'
    });
    $('down').setStyle({
      display: 'block'
    });
  }
});

document.observe("dom:loaded", function() {
  obj = $('inner-content'); /* document.getElementById('inner-content'); */
  obj.up = false;
	obj.down = false;
	obj.fast = false;
	height = Element.viewportOffset('copyright')[1] - Element.viewportOffset('content')[1];
  
  showHome();
  
  if (((obj.offsetHeight+obj.offsetTop) <= height) && (obj.offsetTop == 0)) {
    $('up').setStyle({
      display: 'none'
    });
    $('down').setStyle({
      display: 'none'
    });
  } else {
    $('up').setStyle({
      display: 'block'
    });
    $('down').setStyle({
      display: 'block'
    });
  }
  
  obj.interval = new PeriodicalExecuter(function(pe) {
    var newTop;
  	var objHeight = obj.offsetHeight;
  	var top = obj.offsetTop;
  	var fast = (obj.fast) ? 5 : 3;
  	if(obj.down){		 
  		//newTop = ((objHeight+top) > height) ? top-(speed*fast) : top;	
  		if ((objHeight+top) > height) {
  		  if ((objHeight+(top-(speed*fast))) >= height) {
  		    newTop = top-(speed*fast);
		    } else {
		      newTop = height - objHeight;
		    }
  		} else {
  		  newTop = top;
  		}
  		obj.style.top = newTop + "px";
  	};	
  	if(obj.up){		 
  		//newTop = (top < 0) ? top+(speed*fast) : top;
  		if (top < 0) {
  		  if ((top+(speed*fast)) <= 0) {
  		    newTop = top+(speed*fast);
  		  } else {
  		    newTop = 0;
  		  }
  		} else {
  		  newTop = 0;
  		}
  		obj.style.top = newTop + "px";
  	};
  	
  	// Check if hit top or bottom, so we hide the arrow in case user needs to click on something under it.
  	if ((objHeight+top) <= height) {
      $('down').setStyle({
        display: 'none'
      });
    } else {
      $('down').setStyle({
        display: 'block'
      });
    }
    if (top >= 0) {
      $('up').setStyle({
        display: 'none'
      });
    } else {
      $('up').setStyle({
        display: 'block'
      });
    }
  }, 0.05);

  $('up').observe('mouseover', function(event){
  	obj.up = true;
  });
  
  $('up').observe('mouseout', function(event){
  	obj.up = false;
  });
  
  $('down').observe('mouseover', function(event){
  	obj.down = true;
  });
  
  $('down').observe('mouseout', function(event){
  	obj.down = false;
  });		
  
  $('up').observe('mousedown', goFaster);
  $('down').observe('mousedown', goFaster); 
  function goFaster(event){
  	obj.fast = true;
  };	
  
  $('up').observe('mouseup', goSlower);
  $('down').observe('mouseup', goSlower);
  function goSlower(event){
  	obj.fast = false;
  };		
});
