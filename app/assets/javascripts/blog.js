(function() {
  window.Blog = {
    zclipFun: function(self, i) {
      return $(self).zclip({
        path: "http://solfie-cdn.qiniudn.com/ZeroClipboard-1.1.1.swf",
        copy: function() {
          return $("#img_url_" + i).val();
        }
      });
    },
    removeBlog: function(markdown) {
      $("#myModal2 input[type='text']").val(markdown);
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
