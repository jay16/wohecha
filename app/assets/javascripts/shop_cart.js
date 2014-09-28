(function() {
  window.ShopCart = {
    chkTotal: function() {
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
      return ShopCart.chkTotal();
    },
    minus: function(input_id, price) {
      var $quantity, count;
      $quantity = $("#" + input_id + "_quantity");
      count = parseInt($quantity.attr("value"));
      if (count >= 1) {
        count = count - 1;
        $quantity.attr("value", count);
        $("#" + input_id + "_amount").text(Math.round(count * price * 10) / 10);
        return ShopCart.chkTotal();
      }
    },
    dynaResizeShopCart: function() {
      var width;
      width = $(window).width();
      if (width > 550) {
        return $(".dyna-hidden").removeClass("hidden");
      } else {
        return $(".dyna-hidden").addClass("hidden");
      }
    },
    initShopCart: function() {
      var i, obj, pair, pairs;
      pairs = window.location.search.substring(1).split("&");
      obj = {};
      for (i in pairs) {
        if (pairs[i] === "") {
          continue;
        }
        pair = pairs[i].split("=");
        obj[decodeURIComponent(pair[0])] = decodeURIComponent(pair[1]);
      }
      if (obj["tea"]) {
        return $("#tea_" + obj["tea"]).find(".plus").trigger("click");
      }
    }
  };

  $(function() {
    ShopCart.initShopCart();
    ShopCart.chkTotal();
    return ShopCart.dynaResizeShopCart();
  });

  $(window).resize(ShopCart.dynaResizeShopCart);

}).call(this);
