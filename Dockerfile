FROM hexpm/elixir:1.12.2-erlang-24.0.4-alpine-3.14.0 as builder

# The nuclear approach:
# RUN apk add --no-cache alpine-sdk
RUN apk add --no-cache gcc git make musl-dev
RUN mix local.rebar --force && mix local.hex --force
WORKDIR /app
ENV MIX_ENV=prod
COPY mix.* /app/
RUN mix deps.get --only prod
RUN mix deps.compile

FROM node:14.17 as frontend
WORKDIR /app
COPY assets/package.json assets/yarn.lock /app/
COPY --from=builder /app/deps/phoenix /deps/phoenix
COPY --from=builder /app/deps/phoenix_html /deps/phoenix_html
RUN yarn install
COPY assets /app
RUN npm run deploy

FROM builder as releaser
COPY --from=frontend /priv/static /app/priv/static
COPY . /app/
RUN mix phx.digest
RUN mix release

FROM alpine:3.14.0
RUN apk add -U bash openssl libgcc libstdc++
WORKDIR /app
COPY --from=releaser /app/_build/prod/rel/stein_example /app/
ENV MIX_ENV=prod
EXPOSE 4000
ENTRYPOINT ["bin/stein_example"]
CMD ["start"]
