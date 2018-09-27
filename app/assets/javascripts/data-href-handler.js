$(document).on("turbolinks:load", function() {
  $("[data-href]").on("click", function() {
    var location = $(this).data("href");
    Turbolinks.visit(location);
  });
});
