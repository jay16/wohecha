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
