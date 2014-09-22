(function() {
  window.Teas = {
    "delete": function(id, name) {
      var result;
      result = confirm("确认删除[" + name + "]\n此动作不可撤消!");
      if (result) {
        return Teas.deleteWithAjax(id);
      }
    },
    deleteWithAjax: function(id) {
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
    showAllTeas: function(input) {
      if (App.checkboxState(input)) {
        return $(".tea").removeClass("hidden");
      } else {
        return $(".outsale").addClass("hidden");
      }
    },
    generateStaticFiles: function() {
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
      var count, date_begin, keyword;
      keyword = $(input).val();
      if (!keyword.trim()) {
        $(".tea").removeClass("hidden");
        $(".outsale").addClass("hidden");
        return $(".search-result").text("");
      } else {
        date_begin = new Date();
        count = 0;
        return $(".tea").each(function() {
          var date_end, keywords, search_duration, text;
          keywords = $(this).data("keywords");
          if (keywords.indexOf(keyword) >= 0) {
            $(this).removeClass("hidden");
            count += 1;
          } else {
            $(this).addClass("hidden");
          }
          date_end = new Date();
          search_duration = (date_end.getTime() - date_begin.getTime()) / 1000;
          text = "找到约" + count + "条结果(用时" + search_duration + "秒)";
          return $(".search-result").text(text);
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
