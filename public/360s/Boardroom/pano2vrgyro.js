/*
Based on the krpano iOS 4.2 gyroscope script
by Aldo Hoeben / fieldofview.com
contributions by Sjeiti / ronvalstar.nl

Port for Pano2VR
Thomas Rauscher / gardengnomesoftware.com

This software can be used free of charge and the source code is available under a Creative Commons Attribution license:
http://creativecommons.org/licenses/by/3.0/

*/

function pano2vrGyro(panoObject,containerId) {

	this.enable=function() {
		if (isDeviceEnabled && !isEnabled) {
			window.addEventListener("deviceorientation", handleDeviceOrientation, true);
			container.addEventListener("touchstart", handleTouchStart, true);
			container.addEventListener("touchend", handleTouchEnd, true);		
			container.addEventListener("touchcancel", handleTouchEnd, true);	
			isEnabled = true;
		}
		return isEnabled;
	}

	this.disable=function() {
		if (isDeviceEnabled && isEnabled) {
			window.removeEventListener("deviceorientation", handleDeviceOrientation);
			container.removeEventListener("touchstart", handleTouchStart);
			container.removeEventListener("touchend", handleTouchEnd);		
			container.removeEventListener("touchcancel", handleTouchEnd);	
			isEnabled = false;
		}
		return isEnabled;
	}

	this.toggle=function() {
		if(isEnabled)
			return this.disable();
		else
			return this.enable();
	}

	this.setAdaptiveVOffset=function(arg) {
		if(arg==undefined || arg === null || arg == "")
			isAdaptiveVOffset = !isAdaptiveVOffset;
		else
			isAdaptiveVOffset = Boolean(arg); 
	}

	////////////////////////////////////////////////////////////

	function handleTouchStart(event) {
		isTouching = true;
	}

	function handleTouchEnd(event) {
		isTouching = false;	
	}

	function handleDeviceOrientation(event) {
		if ( !isTouching && isEnabled ) {

			// process event.alpha, event.beta and event.gamma
			var orientation = rotateEuler( new Object( { 
					yaw: event["alpha"] * degRad, 
					pitch: event["beta"] * degRad, 
					roll: event["gamma"] * degRad 
				} ) ),
				yaw = orientation.yaw / degRad,
				pitch = orientation.pitch / degRad,
				altyaw = yaw,
				factor,
				hlookatnow = -panoObj.getPan(),
				vlookatnow = -panoObj.getTilt();

			// fix gimbal lock
			if( Math.abs(pitch) > 70 ) {
				altyaw = event.alpha; 
			
				switch(window.orientation) {
					case 0:
						if ( pitch>0 ) 
							altyaw += 180;
						break;
					case 90: 
						altyaw += 90;
						break;
					case -90: 
						altyaw += -90;
						break;
					case 180:
						if ( pitch<0 ) 
							altyaw += 180;
						break;
				}
			
				altyaw = altyaw % 360;
				if( Math.abs( altyaw - yaw ) > 180 ) 
					altyaw += ( altyaw < yaw ) ? 360 : -360;
			
				factor = Math.min( 1, ( Math.abs( pitch ) - 70 ) / 10 );
				yaw = yaw * ( 1-factor ) + altyaw * factor;
			}
		
			// track view change since last orientation event
			// -> user has manually panned, or krpano has altered lookat
			hoffset += hlookatnow - hlookat;
			voffset += vlookatnow - vlookat;
		
			// clamp voffset
			if(Math.abs( pitch + voffset ) > 90) {
				voffset = ( pitch+voffset > 0 ) ? (90 - pitch) : (-90 - pitch)
			}

			hlookat = (-yaw -180 + hoffset ) % 360;
			vlookat = Math.max(Math.min(( pitch + voffset ),90),-90);

			// dampen lookat
			if(Math.abs(hlookat - hlookatnow) > 180) 
				hlookatnow += (hlookat > hlookatnow)?360:-360;
			hlookat = (1-isEasing)*hlookat + isEasing*hlookatnow;
			vlookat = (1-isEasing)*vlookat + isEasing*vlookatnow;
						
			panoObj.setPan(-hlookat);
			panoObj.setTilt(-vlookat);
			
			adaptVOffset();
		}
	}

	function adaptVOffset() {
		if( voffset != 0 && isAdaptiveVOffset ) {
				voffset *= 0.98;
				if( Math.abs( voffset ) < 0.1 ) {
					voffset = 0;
				}
		}
	}

	function rotateEuler( euler ) {
		// based on http://www.euclideanspace.com/maths/geometry/rotations/conversions/eulerToMatrix/index.htm
		// and http://www.euclideanspace.com/maths/geometry/rotations/conversions/matrixToEuler/index.htm

		var heading, bank, attitude,
			ch = Math.cos(euler.yaw),
			sh = Math.sin(euler.yaw),
			ca = Math.cos(euler.pitch),
			sa = Math.sin(euler.pitch),
			cb = Math.cos(euler.roll),
			sb = Math.sin(euler.roll);

		// note: includes 90 degree rotation around z axis
		matrix = new Array( 
			sh*sb - ch*sa*cb,   -ch*ca,    ch*sa*sb + sh*cb,
			ca*cb,              -sa,      -ca*sb,			
			sh*sa*cb + ch*sb,    sh*ca,   -sh*sa*sb + ch*cb
		);
				
		/* [m00 m01 m02] 0 1 2
		 * [m10 m11 m12] 3 4 5 
		 * [m20 m21 m22] 6 7 8 */
	 
		if (matrix[3] > 0.9999) { // singularity at north pole
			heading = Math.atan2(matrix[2],matrix[8]);
			attitude = Math.PI/2;
			bank = 0;
		} else if (matrix[3] < -0.9999) { // singularity at south pole
			heading = Math.atan2(matrix[2],matrix[8]);
			attitude = -Math.PI/2;
			bank = 0;
		} else {
			heading = Math.atan2(-matrix[6],matrix[0]);
			bank = Math.atan2(-matrix[5],matrix[4]);
			attitude = Math.asin(matrix[3]);
		}
	
		return new Object( { yaw:heading, pitch:attitude, roll:bank } ) 
	}

	///////////////////////////////////////////////////

	var isDeviceEnabled = !!window.DeviceOrientationEvent,
		panoObj,
	
		isEnabled = false,
		isAdaptiveVOffset = false,
		isEasing = 0.5;

		isTouching = false,
	
		hoffset = 0, voffset = 0,
		hlookat = 0, vlookat = 0,
	
		degRad = Math.PI/180;
	
	panoObj=panoObject;
	var container = document.getElementById(containerId);

	hoffset = -panoObj.getPan();
	voffset = -panoObj.getTilt();

	this.enable();

	////////////////////////////////////////////////////////////
}

