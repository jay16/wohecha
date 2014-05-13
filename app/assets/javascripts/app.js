(function() {
  window.App = {
    showLoading: function() {
      return $(".loading").removeClass("hidden");
    },
    hideLoading: function() {
      return $(".loading").addClass("hidden");
    }
  };

}).call(this);
