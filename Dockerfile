FROM hexpm/elixir:1.11.4-erlang-23.2.7.2-alpine-3.13.3 as builder

# The nuclear approach:
# RUN apk add --no-cache alpine-sdk
RUN apk add --no-cache gcc git make musl-dev
RUN mix local.rebar --force && mix local.hex --force
WORKDIR /app
ENV MIX_ENV=prod
COPY mix.* /app/
RUN mix deps.get --only prod
RUN mix deps.compile

FROM node:12.22 as frontend
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

FROM alpine:3.13.3
RUN apk add -U bash openssl
WORKDIR /app
COPY --from=releaser /app/_build/prod/rel/stein_example /app/
ENV MIX_ENV=prod
EXPOSE 4000
ENTRYPOINT ["bin/stein_example"]
CMD ["start"]
