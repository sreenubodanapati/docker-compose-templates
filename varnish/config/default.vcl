vcl 4.1;

import std;

# Backend definition
backend default {
    .host = "backend";
    .port = "80";
    .connect_timeout = 5s;
    .first_byte_timeout = 30s;
    .between_bytes_timeout = 2s;
    .max_connections = 50;
    
    # Health check
    .probe = {
        .url = "/health";
        .timeout = 5s;
        .interval = 30s;
        .window = 5;
        .threshold = 3;
    }
}

# API backend
backend api {
    .host = "api-backend";
    .port = "80";
    .connect_timeout = 5s;
    .first_byte_timeout = 60s;
    .between_bytes_timeout = 2s;
}

# ACL for purging
acl purge {
    "localhost";
    "127.0.0.1";
    "::1";
    "172.16.0.0"/12;
    "192.168.0.0"/16;
    "10.0.0.0"/8;
}

# Receive function - routing logic
sub vcl_recv {
    # Remove port from host header
    set req.http.Host = regsub(req.http.Host, ":[0-9]+", "");
    
    # Route API requests to API backend
    if (req.url ~ "^/api/") {
        set req.backend_hint = api;
    } else {
        set req.backend_hint = default;
    }
    
    # Handle purge requests
    if (req.method == "PURGE") {
        if (!client.ip ~ purge) {
            return (synth(405, "Purging not allowed for " + client.ip));
        }
        return (purge);
    }
    
    # Only cache GET and HEAD requests
    if (req.method != "GET" && req.method != "HEAD") {
        return (pass);
    }
    
    # Don't cache requests with authorization
    if (req.http.Authorization) {
        return (pass);
    }
    
    # Don't cache admin pages
    if (req.url ~ "^/(admin|wp-admin|login)") {
        return (pass);
    }
    
    # Remove cookies for static content
    if (req.url ~ "\.(css|js|png|gif|jp(e)?g|swf|ico|pdf|mov|fla|zip|rar)(\?.*)?$") {
        unset req.http.Cookie;
        return (hash);
    }
    
    # Remove Google Analytics cookies
    if (req.http.Cookie) {
        set req.http.Cookie = regsuball(req.http.Cookie, "__utm[a-z]+=[^;]+(; )?", "");
        set req.http.Cookie = regsuball(req.http.Cookie, "_ga=[^;]+(; )?", "");
        set req.http.Cookie = regsuball(req.http.Cookie, "_gat=[^;]+(; )?", "");
        set req.http.Cookie = regsuball(req.http.Cookie, "utmctr=[^;]+(; )?", "");
        set req.http.Cookie = regsuball(req.http.Cookie, "utmcmd.=[^;]+(; )?", "");
        set req.http.Cookie = regsuball(req.http.Cookie, "utmccn.=[^;]+(; )?", "");
        
        # Remove empty cookies
        if (req.http.Cookie ~ "^\s*$") {
            unset req.http.Cookie;
        }
    }
    
    return (hash);
}

# Backend response handling
sub vcl_backend_response {
    # Set TTL based on content type
    if (beresp.http.Content-Type ~ "image") {
        set beresp.ttl = 1h;
        set beresp.http.Cache-Control = "public, max-age=3600";
    } elsif (beresp.http.Content-Type ~ "text/(css|javascript)") {
        set beresp.ttl = 1h;
        set beresp.http.Cache-Control = "public, max-age=3600";
    } elsif (beresp.http.Content-Type ~ "text/html") {
        set beresp.ttl = 5m;
        set beresp.http.Cache-Control = "public, max-age=300";
    }
    
    # Don't cache error responses
    if (beresp.status >= 400) {
        set beresp.ttl = 0s;
        return (deliver);
    }
    
    # Cache everything for 2 minutes by default
    if (!beresp.http.Cache-Control) {
        set beresp.ttl = 2m;
        set beresp.http.Cache-Control = "public, max-age=120";
    }
    
    # Remove Set-Cookie for cacheable content
    if (beresp.ttl > 0s) {
        unset beresp.http.Set-Cookie;
    }
    
    return (deliver);
}

# Deliver to client
sub vcl_deliver {
    # Add cache hit/miss header
    if (obj.hits > 0) {
        set resp.http.X-Cache = "HIT";
        set resp.http.X-Cache-Hits = obj.hits;
    } else {
        set resp.http.X-Cache = "MISS";
    }
    
    # Add backend response time
    set resp.http.X-Cache-TTL = obj.ttl;
    
    # Remove internal headers
    unset resp.http.Via;
    unset resp.http.X-Varnish;
    
    return (deliver);
}

# Handle synthetic responses (errors, redirects)
sub vcl_synth {
    if (resp.status == 720) {
        # Redirect to HTTPS
        set resp.status = 301;
        set resp.http.Location = "https://" + req.http.Host + req.url;
        return (deliver);
    }
    
    return (deliver);
}
