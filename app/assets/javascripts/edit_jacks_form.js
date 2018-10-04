$(document).on("turbolinks:load", function() {
  $("form.edit_jack, form.new_jack").find("#occupations")
  .on("cocoon:before-insert", beforeInsert)
  .on("cocoon:before-remove", beforeRemove);

  function beforeInsert(e, node) {
    var container = this;
    finalizeLastInserted();
    var assignedTradeIds = $(container)
      .find(".jack_occupations_trade_id[data-trade-id]")
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
      $(".links").hide();
    }
  }

  function beforeRemove(e, node) {
    finalizeLastInserted();
    $(".links").show();
  }

  function finalizeLastInserted(node) {
    node = node || $(".last-inserted")
    node.each(function () {
      console.log("Finalizing", this);
      var tradeName = $(this).find(".jack_occupations_trade_id select :selected").text();
      var tradeId = $(this).find(".jack_occupations_trade_id select").val();
      $(this).find(".trade_id_wrapper")
        .html(`<div class="jack_occupations_trade_id" data-trade-id=${tradeId}>${tradeName}</div>`)
      $(this).removeClass("last-inserted");
    });
  }
});
