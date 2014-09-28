#encoding:utf-8
require File.expand_path "../../../spec_helper.rb", __FILE__

describe "Cpanel::BlogsController" do
  describe "should unauthorized without login" do
    it "should be foribbid when visit /cpanel/blogs" do
      get "/cpanel/blogs"

      expect(last_response).to_not be_ok
      expect(last_response.status).to be(302)
      expect(last_response).to be_redirect

      follow_redirect!
      expect(last_request.url).to eq(redirect_url("/cpanel/login"))
    end
  end

  describe "should operation within login" do
    def post_path
      File.join(Settings.octopress.path, "source/_posts")
    end

    def markdowns
      Dir.glob("%s/*.markdown" % post_path)
    end

    def blog_url_path(post)
      date  = post[0..9].gsub("-", "/")
      title = post[11..-1].sub(".markdown","")
      [Settings.octopress.website, "blog", date, title].join("/")
    end

    before:all do
      post "/cpanel/login", { 
        :name     => Settings.login.name, 
        :password => Settings.login.password
      }

      expect(last_response).to be_redirect
      expect(last_response.status).to be(302)

      follow_redirect!
      expect(last_request.url).to eq(redirect_url("/cpanel"))

      # content
      expect(markdowns.count).to be > 0

      @markdown = File.basename(markdowns.first)
      @list = "/cpanel/blogs"
      @view = "%s/%s" % [@list, @markdown]
      @scan = "%s/%s/scan" % [@list, @markdown]
      @edit = "%s/%s/edit" % [@list, @markdown]
      # delete through js
    end
    it "should show blogs list" do
      get "/cpanel/blogs"

      h1 = "博文列表"
      expect(last_response).to be_ok
      expect(last_response.body).to include(h1)

      markdowns.each do |markdown|
        _markdown = File.basename(markdown)
        view = "%s/%s" % [@list, _markdown]
        scan = "%s/%s/scan" % [@list, _markdown]
        edit = "%s/%s/edit" % [@list, _markdown]

        expect(last_response.body).to include(scan)
        expect(last_response.body).to include(view)
        expect(last_response.body).to include(edit)
      end
      pending "delete fun test with browser"
    end

    it "should contain [scan] [list] [edit] in [view]" do
      get "/cpanel/blogs/%s" % @markdown

      expect(last_response).to be_ok
      expect(last_response.body).to include(@scan)
      expect(last_response.body).to include(@list)
      expect(last_response.body).to include(@edit)
    end

    it "should contain [view] [list] in [edit]" do
      get "/cpanel/blogs/%s/edit" % @markdown

      expect(last_response).to be_ok
      expect(last_response.body).to include(@view)
      expect(last_response.body).to include(@list)
    end

    it "should redirect wiki blog when click [scan]" do
      get "/cpanel/blogs/%s/scan" % @markdown

      expect(last_response).to be_redirect

      follow_redirect!
      expect(last_request.url).to eq(blog_url_path(@markdown))
    end
  end
end
