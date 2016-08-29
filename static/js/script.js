$(function () {
    var count = 0;
    $('#add-button').click(function () {
	var can_button = '#can-button' + count;
	var candidate = '#candidate' + count;
	$('#candidates').append(['<LI CLASS="list-group-item" ID="', 'candidate' + count, '">', $('#candidate').val(), '<BUTTON TYPE="button" CLASS="btn btn-danger btn-xs" ID="', 'can-button' + count, '" STYLE="float: right"><SPAN CLASS="glyphicon glyphicon-minus" ARIA-HIDDEN="true"></SPAN></BUTTON></LI>'].join(''));
	$(can_button).click(function () {
	    $(candidate).remove();
	});
	++count;
    });
    
    $('#submit-button').click(function () {
	var candidates = '';
	for (var i = 0; i < count; i++) {
	    var candidate = '#candidate' + i;
	    var tmp = $(candidate).text();
	    if (tmp != "") {
		candidates += tmp;
		if (i != count-1) {
		    candidates += ",";
		}
	    }
	}
	var data = {
	    name: $('#name').val(),
	    password: $('#password').val(),
	    subject: $('#subject').val(),
	    explanation: $('#explanation').val(),
	    voting_system: $('#voting-system').val(),
	    candidates: candidates
	};
	if (candidates.length == 0 || candidates.length == 1) {
	    alert("Too few candidates.");
	} else {
	    $.ajax({
		type: "POST",
		url: "/submit",
		data: data,
		async: false
		})
		.always(function (data_jqXHR, textStatus, jqXHR_errorThrown) {
		    location.href = "/submitted/" + textStatus;
		});
	}
    });
});
