#encoding: utf-8
window.Transactions =
  search: (input) ->
    keyword = $(input).val()
    # when keyword is empty then show normal
    if !keyword.trim()
      $(".transaction").removeClass("hidden")
      $(".over").addClass("hidden")
    else
      $(".transaction").each ->
        keywords = $(this).data("keywords") 
        if keywords.indexOf(keyword) >= 0
          $(this).removeClass("hidden")
        else
          $(this).addClass("hidden")

  show_all_transactions: (input) ->
    is_checked = $(input).attr("checked")

    if is_checked == "checked"
      $(".transaction").removeClass("hidden")
    else
      $(".over").addClass("hidden")

$ ->
  # detect the change
  $('input#search').bind "change keyup input", ->
    Transactions.search(this)
  
