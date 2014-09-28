#encoding: utf-8
window.Blog = 
  zclipFun: (i, val) ->
    $("#zclipBtn"+i).zclip
      path: "http://solfie-cdn.qiniudn.com/ZeroClipboard-1.1.1.swf"
      copy: ->
        val

  removeBlog: (title, markdown) ->
    $("#inputTitle").val(title)
    $("#inputPost").val(markdown)
    $("#formRemove").attr("action", "/cpanel/blogs/" + markdown)
    $("#myModal2").modal("show")

  inputMonitor: (self, target) ->
    if($.trim($(self).val()).length)
      $(target).removeAttr("disabled")
    else
      $(target).attr("disabled", "disabled")
