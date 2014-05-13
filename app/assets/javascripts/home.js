(function() {
  $(function() {
    return $("input#subscribe").bind("change keyup input", function() {
      if (!$(this).val().trim()) {
        return $("input[type='submit']").removeAttr("disabled");
      } else {
        return $("input[type='submit']").attr("disabled", "disabled");
      }
    });
  });

}).call(this);
