using Test
using Dash
using Dash: ApplicationResources, main_registry, HandlerState
using HTTP



@testset "external_stylesheets" begin    
    app = dash("test app")
    resources = ApplicationResources(app, main_registry()) 
    index_page = Dash.index_page(app, resources)
    
    @test isnothing(findfirst("link rel=\"stylesheet\"", index_page))
    
    app = dash("test app"; external_stylesheets = ["https://test.css"])
    resources = ApplicationResources(app, main_registry()) 
    index_page = Dash.index_page(app, resources)
    @test !isnothing(findfirst("<link rel=\"stylesheet\" href=\"https://test.css\">", index_page))

    app = dash("test app"; external_stylesheets = [
        "https://test.css",
         Dict("href" => "https://test2.css", "rel" => "stylesheet")
         ]
         )
    resources = ApplicationResources(app, main_registry()) 
    index_page = Dash.index_page(app, resources)
    
    @test !isnothing(findfirst("<link rel=\"stylesheet\" href=\"https://test.css\">", index_page))
    @test !isnothing(findfirst("href=\"https://test2.css\"", index_page))
    
end

@testset "external_scripts" begin
    
    
    app = dash("test app"; external_scripts = ["https://test.js"])
    resources = ApplicationResources(app, main_registry()) 
    index_page = Dash.index_page(app, resources)
    @test !isnothing(findfirst("""<script src="https://test.js"></script>""", index_page))

    app = dash("test app"; external_scripts = [
        "https://test.js",  
        Dict("src" => "https://test2.js", "crossorigin" => "anonymous")
        ])
    resources = ApplicationResources(app, main_registry()) 
    index_page = Dash.index_page(app, resources)

    @test !isnothing(findfirst("""<script src="https://test.js"></script>""", index_page))
    
    @test !isnothing(findfirst("""<script src="https://test2.js" crossorigin="anonymous"></script>""", index_page))

end

@testset "url paths" begin
    #=app = dash("test app"; requests_pathname_prefix = "/reg/prefix/", routes_pathname_prefix = "/prefix/")
    resources = ApplicationResources(app, main_registry()) 
    index_page = Dash.index_page(app, resources)
    
    @test !isnothing(findfirst("""requests_pathname_prefix":"/reg/prefix/""", index_page))
    handler = Dash.make_handler(app)
    request = HTTP.Request("GET", "/prefix/")
    response = handler(request)
    @test response.status == 200

    request = HTTP.Request("GET", "/prefix/_dash-layout")
    response = handler(request)
    @test response.status == 200

    request = HTTP.Request("GET", "/prefix/_dash-dependencies")
    response = handler(request)
    @test response.status == 200=#
        
end

@testset "assets paths" begin
    app = dash("test app")
    state = HandlerState(app)
    request = HTTP.Request("GET", "/assets/test.png")
    res = Dash.process_assets(request, state)
    @test res.status == 200
    request = HTTP.Request("GET", "/assets/test3.png")
    res = Dash.process_assets(request, state)
    @test res.status == 404
    request = HTTP.Request("GET", "/images/test.png")
    res = Dash.process_assets(request, state)
    @test res.status == 404

    app = dash("test app", url_base_pathname = "/test/")
    state = HandlerState(app)
    request = HTTP.Request("GET", "/assets/test.png")
    res = Dash.process_assets(request, state)
    @test res.status == 404
    request = HTTP.Request("GET", "/test/assets/test.png")
    res = Dash.process_assets(request, state)
    @test res.status == 200
    request = HTTP.Request("GET", "/images/test.png")
    res = Dash.process_assets(request, state)
    @test res.status == 404

    app = dash("test app", assets_url_path = "ass")
    state = HandlerState(app)
    request = HTTP.Request("GET", "/ass/test.png")
    res = Dash.process_assets(request, state)
    @test res.status == 200
    request = HTTP.Request("GET", "/ass/test3.png")
    res = Dash.process_assets(request, state)
    @test res.status == 404
    request = HTTP.Request("GET", "/assets/test3.png")
    res = Dash.process_assets(request, state)
    @test res.status == 404
    request = HTTP.Request("GET", "/images/test.png")
    res = Dash.process_assets(request, state)
    @test res.status == 404

    app = dash("test app", assets_folder = "images")
    state = HandlerState(app)
    request = HTTP.Request("GET", "/assets/test.png")
    res = Dash.process_assets(request, state)
    @test res.status == 404
    request = HTTP.Request("GET", "/assets/test_images.png")
    res = Dash.process_assets(request, state)
    @test res.status == 200
    request = HTTP.Request("GET", "/images/test.png")
    res = Dash.process_assets(request, state)
    @test res.status == 404
end

@testset "suppress_callback_exceptions" begin
    app = dash("test app")
    resources = ApplicationResources(app, main_registry()) 
    index_page = Dash.index_page(app, resources)
    @test !isnothing(findfirst("\"suppress_callback_exceptions\":false", index_page))
    @test isnothing(findfirst("\"suppress_callback_exceptions\":true", index_page))

    app = dash("test app", suppress_callback_exceptions = true)
    resources = ApplicationResources(app, main_registry()) 
    index_page = Dash.index_page(app, resources)
    @test isnothing(findfirst("\"suppress_callback_exceptions\":false", index_page))
    @test !isnothing(findfirst("\"suppress_callback_exceptions\":true", index_page))
end

@testset "meta_tags" begin
    app = dash("test app")
    resources = ApplicationResources(app, main_registry()) 
    index_page = Dash.index_page(app, resources)
    
    @test !isnothing(
        findfirst(
            "<meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\">",
            index_page)
        )

    @test !isnothing(
        findfirst(
            "<meta charset=\"UTF-8\">",
            index_page)
        )

    app = dash("test app", meta_tags = [Dict("type" => "tst", "rel" => "r")])
    resources = ApplicationResources(app, main_registry()) 
    index_page = Dash.index_page(app, resources)

    @test !isnothing(
            findfirst(
                "<meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\">",
                index_page)
            )
    
    @test !isnothing(
            findfirst(
                "<meta charset=\"UTF-8\">",
                index_page)
            )
    
    @test !isnothing(
        findfirst(
            Dash.format_tag("meta", Dict("type" => "tst", "rel" => "r"), opened = true),
            index_page)
        )

 app = dash("test app", meta_tags = [Dict("charset" => "Win1251"), Dict("type" => "tst", "rel" => "r")])
    resources = ApplicationResources(app, main_registry()) 
    index_page = Dash.index_page(app, resources)

    @test isnothing(
            findfirst(
                "<meta charset=\"UTF-8\">",
                index_page)
            )
    @test !isnothing(
        findfirst(
            "<meta charset=\"Win1251\">",
            index_page)
        )

    @test !isnothing(
        findfirst(
            Dash.format_tag("meta", Dict("type" => "tst", "rel" => "r"), opened = true),
            index_page)
        )

    app = dash("test app", meta_tags = [Dict("http-equiv" => "X-UA-Compatible", "content" => "IE"), Dict("type" => "tst", "rel" => "r")])
    resources = ApplicationResources(app, main_registry()) 
    index_page = Dash.index_page(app, resources)
    @test isnothing(
        findfirst(
            "<meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\">",
            index_page)
        )
    @test !isnothing(
            findfirst(
                Dash.format_tag("meta", Dict("http-equiv" => "X-UA-Compatible", "content" => "IE"), opened = true),
                index_page)
            )

end

@testset "index_string" begin
    index_string = "test test test, {%metas%},{%title%},{%favicon%},{%css%},{%app_entry%},{%config%},{%scripts%},{%renderer%}"
    app = dash("test", index_string = index_string)
    resources = ApplicationResources(app, main_registry()) 
    index_page = Dash.index_page(app, resources)
    @test startswith(index_page, "test test test,")  
    
end

@testset "show_undo_redo" begin
    
    app = dash("test")
    
    resources = ApplicationResources(app, main_registry()) 
    index_page = Dash.index_page(app, resources)
    @test !isnothing(findfirst("\"show_undo_redo\":false", index_page))

    app = dash("test", show_undo_redo = true)
    
    resources = ApplicationResources(app, main_registry()) 
    index_page = Dash.index_page(app, resources)
    @test !isnothing(findfirst("\"show_undo_redo\":true", index_page))
end
