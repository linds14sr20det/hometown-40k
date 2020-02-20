$(function() {
    $(".js-registrantLink").click(function (event) {
        if (event.target.type == "checkbox") {
            return null;
        }
        window.location = $(this).data("link")
    });
});
