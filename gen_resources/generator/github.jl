#= ================ Code copied from BinaryBuilder.jl ============== =#
#=
Since this code is not part of the public BinaryBuilder interface, it is safer to copy it than to use it directly by adding a dependency to BinaryBuider
=#

# This is a global github authentication token that is set the first time
# we authenticate and then reused
const _github_auth = Ref{GitHub.Authorization}()

function github_auth(;allow_anonymous::Bool=true)
    if !isassigned(_github_auth) || !allow_anonymous && isa(_github_auth[], GitHub.AnonymousAuth)
        # If the user is feeding us a GITHUB_TOKEN token, use it!
        if length(get(ENV, "GITHUB_TOKEN", "")) >= 40
            _github_auth[] = GitHub.authenticate(ENV["GITHUB_TOKEN"])
        else
            if allow_anonymous
                _github_auth[] = GitHub.AnonymousAuth()
            else
                # If we're not allowed to return an anonymous authorization,
                # then let's create a token.
                _github_auth[] = GitHub.authenticate(obtain_token())
            end
        end
    end

    return _github_auth[]
end

function obtain_token(; outs=stdout, github_api=GitHub.DEFAULT_API)
    println(outs)
    printstyled(outs, "Authenticating with GitHub\n", bold=true)


    @label retry

    headers = Dict{String, String}("User-Agent"=>"BinaryBuilder-jl",
        "Accept"=>"application/json")

    # Request device authentication flow for BinaryBuilder OAauth APP
    resp = HTTP.post("https://github.com/login/device/code", headers,
        "client_id=8c496f428c48a1015b9e&scope=public_repo")
    if resp.status != 200
        GitHub.handle_response_error(resp)
    end
    reply = JSON.parse(HTTP.payload(resp, String))

    println(outs, """
    To continue, we need to authenticate you with GitHub. Please navigate to
    the following page in your browser and enter the code below:

         $(HTTP.URIs.unescapeuri(reply["verification_uri"]))

         #############
         # $(reply["user_code"]) #
         #############
    """)

    interval = reply["interval"]
    device_code = reply["device_code"]
    while true
        # Poll for completion
        sleep(interval)
        resp = HTTP.post("https://github.com/login/oauth/access_token", headers,
            "client_id=8c496f428c48a1015b9e&grant_type=urn:ietf:params:oauth:grant-type:device_code&device_code=$device_code")

        if resp.status != 200
            GitHub.handle_response_error(resp)
        end


        token_reply = JSON.parse(HTTP.payload(resp, String))
        if haskey(token_reply, "error")
            error_kind = token_reply["error"]
            if error_kind == "authorization_pending"
                continue
            elseif error_kind == "slow_down"
                @warn "GitHub Auth rate limit exceeded. Waiting 10s. (This shouldn't happen)"
                sleep(10)
            elseif error_kind == "expired_token"
                @error "Token request expired. Starting over!"
                @goto retry
            elseif error_kind == "access_denied"
                @error "Authentication request canceled by user. Starting over!"
                @goto retry
            elseif error_kind in ("unsupported_grant_type",
                "incorrect_client_credentials", "incorrect_device_code")
                error("Received error kind $(error_kind). Please file an issue.")
            else
                error("Unexpected GitHub login error $(error_kind)")
            end
        end

        token = token_reply["access_token"]

        print(outs, """
        Successfully obtained GitHub authorization token!
        This token will be used for the rest of this BB session.
        You will have to re-authenticate for any future session.
        However, if you wish to bypass this step, you may create a
        personal access token at """)
        printstyled("https://github.com/settings/tokens"; bold=true)
        println("\n and add the token to the")
        printstyled(outs, "~/.julia/config/startup.jl"; bold=true)
        println(outs, " file as:")
        println(outs)

        printstyled(outs, "    ENV[\"GITHUB_TOKEN\"] = <token>"; bold=true)
        println(outs)

        println(outs, "This token is sensitive, so only do this in a computing environment you trust.")
        println(outs)

        return token
    end
end
