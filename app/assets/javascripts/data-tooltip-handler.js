$(document).on("turbolinks:load", function() {
  $('[data-toggle="tooltip"]').tooltip();
});

$(document).on("turbolinks:before-cache", function() {
  $('[data-toggle="tooltip"]').tooltip("hide");
});
