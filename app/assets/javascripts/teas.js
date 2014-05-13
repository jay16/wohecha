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
    },
    show_all_teas: function(input) {
      var is_checked;
      is_checked = $(input).attr("checked");
      if (is_checked === "checked") {
        return $(".tea").removeClass("hidden");
      } else {
        return $(".outsale").addClass("hidden");
      }
    },
    generate_static_files: function() {
      App.showLoading();
      return $.ajax({
        url: "/admin/generate",
        type: "post",
        success: function(data) {
          $("#myModalContent").html(data);
          $("#myModal").modal("show");
          return App.hideLoading();
        }
      });
    },
    search: function(input) {
      var count, keyword;
      keyword = $(input).val();
      if (!keyword.trim()) {
        $(".tea").removeClass("hidden");
        $(".outsale").addClass("hidden");
        return $(".search-result").text("");
      } else {
        count = 0;
        return $(".tea").each(function() {
          var keywords;
          keywords = $(this).data("keywords");
          if (keywords.indexOf(keyword) >= 0) {
            $(this).removeClass("hidden");
            count += 1;
          } else {
            $(this).addClass("hidden");
          }
          return $(".search-result").text("[" + count + "] results.");
        });
      }
    }
  };

  $(function() {
    return $('input#search').bind("change keyup input", function() {
      return Teas.search(this);
    });
  });

}).call(this);
