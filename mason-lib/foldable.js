var oScroller = {
    callRate   : 10,
    slideTime  : 500,
    isDOM       : document.all ? true : false
};
oScroller.go = function( tt, interval, do_after ) {
	var now    = new Date()
	this.targetTop = tt;
	this.slideTime = interval;
	this.after = do_after;
	this.scrollTop  = this.isDOM ? document.body.scrollTop : window.pageYOffset

//	alert("browser is " + ( this.isDOM ? "DOM" : "not DOM" ) );
	this.A = this.targetTop - this.scrollTop;
	this.B     = Math.PI / ( 2 * (1.2 * this.slideTime ) )
	this.C     = now.getTime()
	this.D     = this.scrollTop

	this.slide();
}
oScroller.slide = function() {
	var now = new Date();
	var newY;

	var progress = ( now.getTime() - this.C ) / this.slideTime;

	if( progress > 1.5 ) {
		scrollTo(0,this.targetTop)
		if( this.after ) 
			eval(this.after);
		return;
	}

	newY  = this.A * Math.sin( this.B * ( now.getTime() - this.C ) ) + this.D
	newY      = Math.round( newY )
	
	scrollTo(0,newY);
	if( newY != this.targetTop ) {
		setTimeout("oScroller.slide()",this.callRate);
	} else {
		if( this.after ) 
			eval(this.after);
	}
}

function fold_it(th,that,single) {
	var thatEl = getEl( that );
	var thisEl = getEl( th );
	if (thatEl.style.display == 'none' ) {
		thatEl.style.display='block';

		var browser_bottom = scrollPos() + winHeight();
		var div_top = elTop(thatEl);
		var div_bottom = div_top + elHeight(that)

		// scroll the browser to be sure the entire element is onscreen.
                if( div_bottom + 30 > browser_bottom ) {
			var target = div_bottom - winHeight() + 30;
			if( target > ( div_top - 20 ) ) 
				target = div_top - 20;
			oScroller.go( target, 200, 0 );
		}
		if( ! single ) 
			thisEl.src='/i/fold.gif';
	} else {
//		if( we're scrolled to within this distance of the doc-bottom )
//			scroll up a bit, *then* hide the layer
//			"this distance" is the height of the layer...
		if( 0 && scrollPos() + winHeight() + elHeight(that) > docHeight() ) {
			var target = Math.max(scrollPos() - elHeight(that),0);
			oScroller.go( target, 700, "getEl('"+that+"').style.display='none'")
		} else {
			thatEl.style.display='none';
		}
		if( ! single ) 
			thisEl.src='/i/unfold.gif';
        }
}

// Copyright 1999-2009 Randy Harmon
//
// Hod is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or   
// (at your option) any later version.
//
// Hod is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
// GNU General Public License for more details (in the LICENSE file).           
//
// You should have received a copy of the GNU General Public License
// along with Hod.  If not, see <http://www.gnu.org/licenses/>.
