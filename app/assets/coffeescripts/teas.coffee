#encoding: utf-8
window.Teas=
  delete: (id, name) ->
    result = confirm("确认删除["+name+"]\n此动作不可撤消!")
    Teas.deleteWithAjax(id) if result

  deleteWithAjax: (id) ->
    $.ajax(
      type: "delete"
      url: "/cpanel/teas/"+id
      #data: { "id": id }
      #dataType: "json"
      success: (data) ->
        window.location.reload()
      error: ->
        alert("error:delete with ajax!")
    );

  showAllTeas: (input) ->
    if App.checkboxState(input)
      App.checkboxUnChecked(input)
      $(".outsale").addClass("hidden")
    else
      App.checkboxChecked(input)
      $(".tea").removeClass("hidden") 

      
  #generate static files with ajax
  #trigger to generate static files
  generateStaticFiles: ->
    App.showLoading()
    $.ajax
      url: "/cpanel/generate"
      type: "post"
      success: (data) ->
        $("#myModalContent").html data
        $("#myModal").modal "show"
        App.hideLoading()

  # search tea with keywords 
  search: (input) ->
    keyword = $(input).val()
    # when keyword is empty then show normal
    if !keyword.trim()
      $(".tea").removeClass("hidden")
      $(".outsale").addClass("hidden")
      $(".search-result").text("")
    else
      date_begin = new Date()
      count = 0
      $(".tea").each ->
        keywords = $(this).data("keywords") 
        if keywords.indexOf(keyword) >= 0
          $(this).removeClass("hidden")
          count += 1
        else
          $(this).addClass("hidden")

        date_end = new Date()
        search_duration = (date_end.getTime() - date_begin.getTime())/1000
        text = "找到约"+count+"条结果(用时" + search_duration+ "秒)"

        $(".search-result").text(text)

$ ->
  # detect the change
  $('input#search').bind "change keyup input", ->
    Teas.search(this)
