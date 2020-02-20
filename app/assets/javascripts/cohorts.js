$(function() {
    $(".js-cohortLink").click(function () {
        window.location = $(this).data("link")
    });
});
