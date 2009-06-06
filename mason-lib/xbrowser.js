var isDOM = (document.getElementById ? true : false); 
var isIE4 = ((document.all && !isDOM) ? true : false);
var isNS4 = (document.layers ? true : false);
var isDyn = (isDOM || isIE4 || isNS4);

function getEl(id)
{
if(isDOM)return document.getElementById(id)
if(isIE4)return document.all[id]
if(isNS4)return document.layers[id]
}
function elHeight(id) {
var d=getEl(id);
var s=d.clientHeight||d.offsetHeight||d.document.height
return(s);
}
function docHeight() {
var h = document.body.lastChild;
h = elTop(h) + h.clientHeight;
return h;
}
function winHeight() {
return window.innerHeight||document.body.clientHeight
}
function scrollPos() {
return window.pageYOffset||document.body.scrollTop;
}
function elTop(el) {
   var oCurrentNode=el;
   var iTop=0;
   while(oCurrentNode.tagName!="BODY"){
      iTop+=oCurrentNode.offsetTop;
      oCurrentNode=oCurrentNode.offsetParent;
   }
   return iTop;
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
