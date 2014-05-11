(function() {
  window.Transactions = {
    search: function(input) {
      var keyword;
      keyword = $(input).val();
      if (!keyword.trim()) {
        $(".transaction").removeClass("hidden");
        return $(".over").addClass("hidden");
      } else {
        return $(".transaction").each(function() {
          var keywords;
          keywords = $(this).data("keywords");
          if (keywords.indexOf(keyword) >= 0) {
            return $(this).removeClass("hidden");
          } else {
            return $(this).addClass("hidden");
          }
        });
      }
    },
    show_all_transactions: function(input) {
      var is_checked;
      is_checked = $(input).attr("checked");
      if (is_checked === "checked") {
        return $(".transaction").removeClass("hidden");
      } else {
        return $(".over").addClass("hidden");
      }
    }
  };

  $(function() {
    return $('input#search').bind("change keyup input", function() {
      return Transactions.search(this);
    });
  });

}).call(this);
