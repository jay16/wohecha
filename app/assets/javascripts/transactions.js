(function() {
  window.Transactions = {
    search: function(input) {
      var count, keyword;
      keyword = $(input).val();
      if (!keyword.trim()) {
        $(".transaction").removeClass("hidden");
        $(".over").addClass("hidden");
        return $(".search-result").text("");
      } else {
        count = 0;
        return $(".transaction").each(function() {
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
