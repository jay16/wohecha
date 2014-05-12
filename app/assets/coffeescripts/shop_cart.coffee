#encoding: utf-8
window.ShopCart =
  chk_total: ->
    total_amount = 0 #购物车商品总金额
    total_quantity= 0 #购物车商品数量
    order_list = new Array()
    $(".tea").each ->
      name = $(this).find(".name:first").html()               #商品名称
      price = parseFloat($(this).find(".price:first").html()) #商品价格
      price = Math.round(price*10)/10                         # 保留一位小数
      quantity = parseInt($(this).find(".quantity:first").val()) #购物中该商品数量

      total_quantity += quantity
      total_amount += Math.round(price * quantity * 10)/10

      if quantity > 0 #购物车商品列表
        json = { "name": name, "quantity": quantity, "price": price }
        order_list.push(JSON.stringify(json))

      # 更新[小计]数值
      $(this).find(".amount:first").text(Math.round(price * quantity * 10)/10)

      #商品选购数量为0时，<减小>按钮不可用
      if quantity == 0
        $(this).find(".minus").attr("disabled", "disabled")
      else
        $(this).find(".minus").removeAttr("disabled")

    total_amount = Math.round(total_amount*10)/10
    $(".total-amount").text(total_amount)
    $(".total-quantity").text(total_quantity)

    #合计行-购物车商品数量、金额明细
    $("#quantity").attr("value", total_quantity)
    $("#amount").attr("value", total_amount)
    $("#order").attr("value", order_list.toString())
    #购物车为空时，提交按钮不可用
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
    ShopCart.chk_total()

  minus: (input_id, price) ->
    $quantity = $("#" + input_id+"_quantity")
    count = parseInt($quantity.attr("value"))
    if count >= 1
      count = count - 1
      $quantity.attr("value", count)
      $("#"+input_id+"_amount").text(Math.round(count*price*10)/10)
      ShopCart.chk_total()

  dyna_resize_shop_cart: ->
    # Get the dimensions of the viewport
    width = $(window).width()
    if width > 550
      $(".dyna-hidden").removeClass "hidden"
    else
      $(".dyna-hidden").addClass "hidden"


# do when load this
$ -> 
  ShopCart.chk_total()
  ShopCart.dyna_resize_shop_cart

$(window).resize ShopCart.dyna_resize_shop_cart
