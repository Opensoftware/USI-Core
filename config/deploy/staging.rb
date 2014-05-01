role :app, %w{opensoftware.pl}
role :web, %w{opensoftware.pl}
role :db,  %w{opensoftware.pl}


# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server definition into the
# server list. The second argument is a, or duck-types, Hash and is
# used to set extended properties on the server.

server 'opensoftware.pl', user: 'rails', roles: %w{web app}
