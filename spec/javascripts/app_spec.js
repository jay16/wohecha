describe("App", function() {

  beforeEach(function() {
    loadFixtures("application.html");
  });

  it("should hide the loading dialog", function() {
    App.hideLoading();
    expect($(".loading").hasClass('hidden')).toBeTruthy()
  });

  it("should show the loading dialog", function() {
    App.showLoading();
    expect($(".loading").hasClass('hidden')).not.toBeTruthy()
  });

  it("should show the loading dialog with customer text", function() {
    var date = new Date();
    var text = date.toUTCString();

    App.showLoading(text)
    expect($(".loading").html()).toEqual(text)
  });

  it("should reset the loading text when hide", function() {
    App.hideLoading()

    expect($(".loading").html()).toEqual("loading...")
  });

});
