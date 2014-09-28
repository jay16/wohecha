(function() {
  window.App = {
    showLoading: function() {
      return $(".loading").removeClass("hidden");
    },
    showLoading: function(text) {
      $(".loading").html(text);
      return $(".loading").removeClass("hidden");
    },
    hideLoading: function() {
      $(".loading").addClass("hidden");
      return $(".loading").html("loading...");
    },
    checkboxState: function(self) {
      var state;
      state = $(self).attr("checked");
      if (state === void 0 || state === "undefined") {
        return false;
      } else {
        return true;
      }
    },
    checkboxChecked: function(self) {
      return $(self).attr("checked", "true");
    },
    checkboxUnChecked: function(self) {
      return $(self).removeAttr("checked");
    },
    checkboxState1: function(self) {
      var state;
      state = $(self).attr("checked");
      if (state === void 0 || state === "undefined") {
        $(self).attr("checked", "true");
        return true;
      } else {
        $(self).removeAttr("checked");
        return false;
      }
    }
  };

  NProgress.configure({
    speed: 500
  });

  $(function() {
    var pathname;
    NProgress.start();
    $("body").tooltip({
      selector: "[data-toggle=tooltip]",
      container: "body"
    });
    NProgress.set(0.2);
    $("body").popover({
      selector: "[data-toggle=popover]",
      container: "body"
    });
    NProgress.set(0.4);
    pathname = window.location.pathname;
    $(".navbar-nav:first li").each(function() {
      var href;
      href = $(this).children("a:first").attr("href");
      if (pathname === href) {
        return $(this).addClass("active");
      } else {
        return $(this).removeClass("active");
      }
    });
    NProgress.set(0.8);
    return NProgress.done(true);
  });

}).call(this);
