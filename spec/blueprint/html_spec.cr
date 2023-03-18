require "../spec_helper"

private class ExamplePage
  include Blueprint::HTML

  private def blueprint
    render BaseLayout.new do
      header do
        h1 { "Test page" }
        h4 { "Page description" }
      end

      div class: "bg-gray-200" do
        p(data: {id: 54, highlight: true}) { "Page text" }

        plain "Plain text"

        iframe src: "example.com"

        render CardComponent.new do |c|
          c.body { "Card body" }
          c.footer do
            a(href: "/about") { "About" }
          end
          footer do
            card_footer_text
          end
        end
      end

      render FooterComponent.new
    end
  end

  private def card_footer_text
    "Card footer text"
  end
end

private class BaseLayout
  include Blueprint::HTML

  def blueprint(&)
    doctype

    html do
      head do
        title { "Test page" }

        meta charset: "utf-8"

        link href: "app.css", rel: "stylesheet"
        script type: "text/javascript", src: "app.js"
      end

      body do
        yield
      end
    end
  end
end

private class FooterComponent
  include Blueprint::HTML

  def blueprint
    footer do
      label(for: "email") { "Email" }
      input type: "text", id: "email"
      span { "Footer" }
    end
  end
end

private class CardComponent
  include Blueprint::HTML

  def blueprint(&)
    div class: "flex flex-col gap-2 bg-white border shadow" do
      yield
    end
  end

  def body(&)
    div class: "p-4" do
      yield
    end
  end

  def footer(&)
    div class: "px-4 py-2" do
      yield
    end
  end
end

describe Blueprint::HTML do
  describe "#to_html" do
    it "renders html" do
      page = ExamplePage.new
      expected_html = <<-HTML.strip.gsub(/\n\s+/, "")
        <!DOCTYPE html>
        <html>
          <head>
            <title>Test page</title>

            <meta charset="utf-8">

            <link href="app.css" rel="stylesheet">
            <script type="text/javascript" src="app.js"></script>
          </head>

          <body>
            <header>
              <h1>Test page</h1>
              <h4>Page description</h4>
            </header>

            <div class="bg-gray-200">
              <p data-id="54" data-highlight="true">Page text</p>

              Plain text

              <iframe src="example.com"></iframe>

              <div class="flex flex-col gap-2 bg-white border shadow">

                <div class="p-4">
                  Card body
                </div>

                <div class="px-4 py-2">
                  <a href="/about">About</a>
                </div>

                <footer>
                  Card footer text
                </footer>
              </div>
            </div>

            <footer>
              <label for="email">Email</label>
              <input type="text" id="email">
              <span>Footer</span>
            </footer>
          </body>
        </html>
      HTML

      html = page.to_html

      html.should eq expected_html
    end
  end
end
