#encoding: utf-8
window.Blog = 
  zclipFun: (i, val) ->
    $("#zclipBtn"+i).zclip
      path: "http://solfie-cdn.qiniudn.com/ZeroClipboard-1.1.1.swf"
      copy: ->
        val

  removeBlog: (markdown) ->
    $("#myModal2 input[type='text']").val(markdown);
    $("#myModal2").modal("show")

  inputMonitor: (self, target) ->
    if($.trim($(self).val()).length)
      $(target).removeAttr("disabled")
    else
      $(target).attr("disabled", "disabled")
