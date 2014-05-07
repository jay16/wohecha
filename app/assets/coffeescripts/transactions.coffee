#encoding: utf-8
window.Teas =
  chk_total: ->
    total_amount = 0
    total_quantity= 0
    order_list = ""
    $(".tea").each ->
      name = $(this).find(".name:first").html()
      price = parseFloat($(this).find(".price:first").html())
      price = Math.round(price*10)/10 # 保留一位小数
      quantity = parseInt($(this).find(".quantity:first").val())
      total_quantity += quantity
      total_amount += Math.round(price * quantity * 10)/10
      order_list += "{ :name => " + name + ", :quantity => " + quantity + ", :price => " + price + "}" if quantity > 0
      $(this).find(".amount:first").text(Math.round(price * quantity * 10)/10)
      #商品选购数量为0时，<减小>按钮不可用
      if quantity == 0
        $(this).find(".minus").attr("disabled", "disabled")
      else
        $(this).find(".minus").removeAttr("disabled")

    $(".total-amount").text(total_amount)
    $(".total-quantity").text(total_quantity)
    $("#quantity").attr("value", total_quantity)
    $("#amount").attr("value", total_amount)
    $("#order").attr("value", order_list)
    if total_amount == 0 
      $("input[type='submit']").attr("disabled","disabled")
    else
      $("input[type='submit']").removeAttr("disabled")

  plus: (input_id, price) ->
    $quantity = $("#" + input_id+"_quantity")
    count = parseInt($quantity.attr("value"))
    count += 1
    $quantity.attr("value", count)
    $("#"+input_id+"_amount").text(Math.round(count*price*10)/10)
    Teas.chk_total()

  minus: (input_id, price) ->
    $quantity = $("#" + input_id+"_quantity")
    count = parseInt($quantity.attr("value"))
    if count >= 1
      count = count - 1
      $quantity.attr("value", count)
      $("#"+input_id+"_amount").text(Math.round(count*price*10)/10)
      Teas.chk_total()

$ -> 
  Teas.chk_total()
