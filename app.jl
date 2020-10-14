using Dash

index_string = "
<!DOCTYPE html>
<html>
    <head>
        {%metas%}
        <title>{%title%}</title>
        {%favicon%}
        {%css%}
             <script>
              (function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
              new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
              j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
              'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
              })(window,document,'script','dataLayer','GTM-N6T2RXG');
            </script>
    </head>
    <body>
         <!-- Google Tag Manager (noscript) -->
              <noscript><iframe src='https://www.googletagmanager.com/ns.html?id=GTM-N6T2RXG'
              height='0' width='0' style='display:none;visibility:hidden'></iframe></noscript>
        <!-- End Google Tag Manager (noscript) -->
        {%app_entry%}
        <footer>
            {%config%}
            {%scripts%}
            {%renderer%}
        </footer>
    </body>
</html>"

app = dash(assets_folder = "./dash_docs/assets", meta_tags = [Dict(["name"=>"description", "content" => "Dash for Julia User Guide and Documentation. Dash is a framework for building analytical web apps in Julia, R, and Python."])], index_string = index_string, suppress_callback_exceptions = true)

app.title = "Dash for Julia User Guide and Documentation | Plotly"
