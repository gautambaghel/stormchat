# Extend from the official Elixir image
FROM elixir:latest

LABEL "homepage"="http://github.com/actions"
LABEL "maintainer"="GitHub Actions <support+actions@github.com>"
LABEL "version"="1.0.0"

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
