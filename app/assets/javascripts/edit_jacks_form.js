$(document).on("turbolinks:load", function() {
  $("form.edit_jack, form.new_jack").find("#occupations")
  .on("cocoon:before-insert", beforeInsert)
  .on("cocoon:before-remove", beforeRemove);

  function beforeInsert(e, node) {
    finalizeLastInserted();
    var container = this;
    var assignedTradeIds = $(container)
      .find(".jack_occupations_trade_id[data-trade-id]:visible")
      .map(function() {
        return $(this).data("trade-id");
      })
      .get();
    var select = $(node).find(".jack_occupations_trade_id select");
    for(var tradeId of assignedTradeIds) {
      select.find(`option[value="${tradeId}"]`).remove();
    }
    $(node).addClass("last-inserted");
    if (select.find("option").length == 1) {
      finalizeLastInserted(node);
      $(".links").addClass("d-none");
    }
  }

  function beforeRemove(e, node) {
    finalizeLastInserted();
    $(".links").removeClass("d-none");
  }

  function finalizeLastInserted(node) {
    node = node || $(".last-inserted")
    node.each(function () {
      var tradeName = $(this).find(".jack_occupations_trade_id select :selected").text();
      var tradeId = $(this).find(".jack_occupations_trade_id select").val();
      var select = $(this).find(".trade_id_wrapper select");
      var hidden = `<input type="hidden" name="${select.attr("name")}" value="${tradeId}">`;
      $(this).find(".trade_id_wrapper")
        .html(`<div class="jack_occupations_trade_id" data-trade-id=${tradeId}>${tradeName}${hidden}</div>`)
      $(this).removeClass("last-inserted");
    });
  }
});
