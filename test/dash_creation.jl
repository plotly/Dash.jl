using Test
using Dash


@testset "default args" begin
    app = dash("test app")
    @test app.name == "test app"
    @test isempty(app.config.external_stylesheets)
    @test isempty(app.config.external_scripts) 
    @test app.config.requests_pathname_prefix == "/"
    @test app.config.routes_pathname_prefix == "/"
    @test app.config.assets_folder == joinpath(pwd(), "assets")
    @test app.config.assets_url_path == "assets"
    @test app.config.assets_ignore == ""
    
    @test app.config.serve_locally == true
    @test app.config.suppress_callback_exceptions == false
    @test app.config.eager_loading == false
    
    @test isempty(app.config.meta_tags) 
    @test app.index_string == Dash.default_index
    @test app.config.assets_external_path == nothing

    @test app.config.include_assets_files == true
    @test app.config.show_undo_redo == false
end

@testset "setted args" begin
    app = dash("test app"; external_stylesheets=["https://test.css"])
    @test app.config.external_stylesheets == ["https://test.css"]

    app = dash("test app"; external_stylesheets=[Dict("url" => "https://test.css", "integrity" => "integrity")])
    @test app.config.external_stylesheets == [
        Dict("url" => "https://test.css", "integrity" => "integrity")
        ]
    
    app = dash("test app"; external_scripts = ["http://test.js"]) 
    @test app.config.external_scripts == ["http://test.js"]

    app = dash("test app"; external_scripts=[Dict("url" => "https://test.js", "integrity" => "integrity")])
    @test app.config.external_scripts == [
        Dict("url" => "https://test.js", "integrity" => "integrity")
        ]

    app = dash("test app"; url_base_pathname = "/base/") 
    @test app.config.url_base_pathname == "/base/"
    @test app.config.requests_pathname_prefix == "/base/"
    @test app.config.routes_pathname_prefix == "/base/"

    app = dash("test app"; requests_pathname_prefix = "/prefix/")
    @test app.config.requests_pathname_prefix == "/prefix/"
    @test app.config.routes_pathname_prefix == "/"

    app = dash("test app"; routes_pathname_prefix = "/prefix/")
    @test app.config.requests_pathname_prefix == "/prefix/"
    @test app.config.routes_pathname_prefix == "/prefix/"

    app = dash("test app"; requests_pathname_prefix = "/reg/prefix/", routes_pathname_prefix = "/prefix/")
    
    @test app.config.requests_pathname_prefix == "/reg/prefix/"
    @test app.config.routes_pathname_prefix == "/prefix/"

    @test_throws ErrorException app = dash("test app"; url_base_pathname = "/base")
    @test_throws ErrorException app = dash("test app"; url_base_pathname = "base/")
    @test_throws ErrorException app = dash("test app"; url_base_pathname = "/", routes_pathname_prefix = "/prefix/")
    @test_throws ErrorException app = dash("test app"; requests_pathname_prefix = "/prefix")
    @test_throws ErrorException app = dash("test app"; routes_pathname_prefix = "/prefix")
    @test_throws ErrorException app = dash("test app"; requests_pathname_prefix = "prefix/")
    @test_throws ErrorException app = dash("test app"; routes_pathname_prefix = "prefix/")
    @test_throws ErrorException app = dash("test app"; requests_pathname_prefix = "/reg/prefix/", routes_pathname_prefix = "/ix/")
    

    app = dash("test app"; assets_folder = "images") 
    @test app.config.assets_folder == joinpath(pwd(), "images")

    app = dash("test app"; assets_url_path = "/images") 
    @test app.config.assets_url_path == "images"

    app = dash("test app"; assets_ignore = "ignore")
    @test app.config.assets_ignore == "ignore"    

    app = dash("test app"; serve_locally = false)
    @test app.config.serve_locally == false

    app = dash("test app"; suppress_callback_exceptions = true)
    @test app.config.suppress_callback_exceptions == true

    app = dash("test app"; eager_loading = false)
    @test app.config.eager_loading == false

    app = dash("test app"; meta_tags = [Dict(["name"=>"test", "content" => "content"])])
    @test app.config.meta_tags == [Dict(["name"=>"test", "content" => "content"])]

    @test_throws ErrorException app = dash("test app"; index_string = "<html></html>")
    app = dash("test app"; index_string = "<html>{%app_entry%}{%config%}{%scripts%}</html>")
    @test app.index_string == "<html>{%app_entry%}{%config%}{%scripts%}</html>"

    app = dash("test app"; assets_external_path = "external")
    @test app.config.assets_external_path == "external"

    app = dash("test app"; include_assets_files = true)
    @test app.config.include_assets_files == true

    app = dash("test app"; show_undo_redo = false)
    @test app.config.show_undo_redo == false
    
end
