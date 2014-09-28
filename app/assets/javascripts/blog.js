(function() {
  window.Blog = {
    zclipFun: function(i, val) {
      return $("#zclipBtn" + i).zclip({
        path: "http://solfie-cdn.qiniudn.com/ZeroClipboard-1.1.1.swf",
        copy: function() {
          return val;
        }
      });
    },
    removeBlog: function(title, markdown) {
      $("#inputTitle").val(title);
      $("#inputPost").val(markdown);
      $("#formRemove").attr("action", "/cpanel/blogs/" + markdown);
      return $("#myModal2").modal("show");
    },
    inputMonitor: function(self, target) {
      if (($.trim($(self).val()).length)) {
        return $(target).removeAttr("disabled");
      } else {
        return $(target).attr("disabled", "disabled");
      }
    }
  };

}).call(this);
