(function() {
  window.Teas = {
    chk_total: function() {
      var order_list, total_amount, total_quantity;
      total_amount = 0;
      total_quantity = 0;
      order_list = new Array();
      $(".tea").each(function() {
        var json, name, price, quantity;
        name = $(this).find(".name:first").html();
        price = parseFloat($(this).find(".price:first").html());
        price = Math.round(price * 10) / 10;
        quantity = parseInt($(this).find(".quantity:first").val());
        total_quantity += quantity;
        total_amount += Math.round(price * quantity * 10) / 10;
        if (quantity > 0) {
          json = {
            "name": name,
            "quantity": quantity,
            "price": price
          };
          order_list.push(JSON.stringify(json));
        }
        $(this).find(".amount:first").text(Math.round(price * quantity * 10) / 10);
        if (quantity === 0) {
          return $(this).find(".minus").attr("disabled", "disabled");
        } else {
          return $(this).find(".minus").removeAttr("disabled");
        }
      });
      total_amount = Math.round(total_amount * 10) / 10;
      $(".total-amount").text(total_amount);
      $(".total-quantity").text(total_quantity);
      $("#quantity").attr("value", total_quantity);
      $("#amount").attr("value", total_amount);
      $("#order").attr("value", order_list.toString());
      if (total_amount === 0) {
        return $("input[type='submit']").attr("disabled", "disabled");
      } else {
        return $("input[type='submit']").removeAttr("disabled");
      }
    },
    plus: function(input_id, price) {
      var $quantity, count;
      $quantity = $("#" + input_id + "_quantity");
      count = parseInt($quantity.attr("value"));
      count += 1;
      $quantity.attr("value", count);
      $("#" + input_id + "_amount").text(Math.round(count * price * 10) / 10);
      return Teas.chk_total();
    },
    minus: function(input_id, price) {
      var $quantity, count;
      $quantity = $("#" + input_id + "_quantity");
      count = parseInt($quantity.attr("value"));
      if (count >= 1) {
        count = count - 1;
        $quantity.attr("value", count);
        $("#" + input_id + "_amount").text(Math.round(count * price * 10) / 10);
        return Teas.chk_total();
      }
    }
  };

  $(function() {
    return Teas.chk_total();
  });

}).call(this);