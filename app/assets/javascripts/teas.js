(function() {
  window.Teas = {
    "delete": function(id, name) {
      var result;
      result = confirm("确认删除[" + name + "]\n此动作不可撤消!");
      if (result) {
        return Teas.delete_with_ajax(id);
      }
    },
    delete_with_ajax: function(id) {
      return $.ajax({
        type: "delete",
        url: "/teas/" + id,
        success: function(data) {
          return window.location.reload();
        },
        error: function() {
          return alert("error:delete with ajax!");
        }
      });
    }
  };

}).call(this);
