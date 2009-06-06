// Form Functions  v1.0
// http://www.dithered.com/javascript/form/index.html
// code by Chris Nott (chris@dithered.com)

// Clear a form so that default initial values are erased
function clearForm(form) {
	var element;
	for (var i = 0; i < form.elements.length; i++) {
		element = form.elements[i];
		if (element.type == "text" || element.type == "password" || element.type == "textarea") element.value = '';
		else if (element.type.indexOf("select") != -1) element.selectedIndex = -1;
		else if (element.type == "checkbox" && element.checked) element.checked = false;
		else if (element.type == "radio" && element.checked == true) element.checked = false;
	}
}


