window.App =
  showLoading :->
    $(".loading").removeClass("hidden")
  hideLoading :->
    $(".loading").addClass("hidden")
