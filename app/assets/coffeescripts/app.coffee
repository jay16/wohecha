#encoding: utf-8
window.App =
  showLoading: ->
    $(".loading").removeClass("hidden")

  showLoading: (text) ->
    $(".loading").html(text)
    $(".loading").removeClass("hidden")

  hideLoading:->
    $(".loading").addClass("hidden")
    $(".loading").html("加载中...")

  checkboxState: (self) ->
    state = $(self).attr("checked")
    if(state == undefined || state == "undefined")
      $(self).attr("checked", "true")
      return true
    else
      $(self).removeAttr("checked")
      return false
