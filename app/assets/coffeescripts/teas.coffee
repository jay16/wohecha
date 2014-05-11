#encoding: utf-8
window.Teas=
  delete: (id, name) ->
    result = confirm("确认删除["+name+"]\n此动作不可撤消!")
    Teas.delete_with_ajax(id) if result

  delete_with_ajax: (id) ->
    $.ajax(
      type: "delete"
      url: "/teas/"+id
      #data: { "id": id }
      #dataType: "json"
      success: (data) ->
        window.location.reload()
      error: ->
        alert("error:delete with ajax!")
    );

  show_all_teas: (input) ->
    is_checked = $(input).attr("checked")

    if is_checked == "checked"
      $(".tea").removeClass("hidden")
    else
      $(".outsale").addClass("hidden")
      

