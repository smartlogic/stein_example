# SteinExample

This is an example Phoenix application that uses [Stein](https://github.com/smartlogic/stein) to it's fullest. See how to handle common user functionality with Stein, such as auth, email verification, password resets, uploading, and more.

You can also clone this repo as a starting point for a new project to get going quickly.

## Setup

Install PostgreSQL through your package manager of choice, or if you're on MacOS you can use [Postgres.app](https://postgresapp.com/). Make sure to have **PostgreSQL 12** or above.

### With ASDF

Install Elixir, Erlang, and NodeJS through [asdf](https://asdf-vm.com/#/) using the versions supplied in `.tool-versions`. Once you have asdf, you can install them all with `asdf install` from the root of the project.

```bash
# Install Erlang/Elixir/NodeJS
asdf install
# Install yarn if required
npm install -g yarn

mix deps.get
mix ecto.setup
(cd assets && yarn install && yarn build)
iex -S mix phx.server
```

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser. See `priv/repo/seeds.exs` for seeded accounts.

### With Nix

Install [the nix package manager](https://nixos.org/download.html#nix-install-macos) by following their multi-user installer. Once nix is installed, setup [direnv](https://direnv.net/) by hooking into your shell.

```bash
nix-env -f '<nixpkgs>' -iA direnv
echo 'eval "$(direnv hook zsh)"' >> ~/.zshrc
```

Once direnv is installed and your shell is restarted, clone the project and `cd` into it. You should see direnv warn about an untrusted `.envrc` file. Allow the file and finish installing dependencies and setting up the application.

```bash
direnv allow

mix deps.get
mix ecto.reset
(cd assets && yarn install && yarn build)
iex -S mix phx.server
```

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser. See `priv/repo/seeds.exs` for seeded accounts.

## Testing

In order to verify our application, we have a series of tests that run in CI. Below is a list of them individually.

```bash
mix format --check-formatted
mix compile --force --warnings-as-errors
mix credo
mix test
(cd assets && yarn lint:ci)
(cd assets && yarn lint:style:ci)
```

Alternatively, you can run them all together with the verify script.

```bash
./verify.sh
```

## Using as a template

**Note: You must follow through with the admin panel section**

```bash
git grep -l SteinExample | xargs sed -i 's/SteinExample/MyApp/g'
git grep -l stein_example | xargs sed -i 's/stein_example/my_app/g'
git mv lib/{stein_example,my_app}
git mv lib/{stein_example,my_app}.ex
git mv test/{stein_example,my_app}
rm -rf .git
git init .
```

**On a Mac**
The first two lines of above will likely need to be changed to the following to work:
```bash
git grep -l SteinExample | xargs sed -i '' 's/SteinExample/MyApp/g'
git grep -l stein_example | xargs sed -i '' 's/stein_example/my_app/g'
```

### Admin Panel

The app ships with the start of an admin panel. Something that you **must do** after getting it set up is add permissioning to the panel. Every signed in user can access the panel from first clone. This is on purpose because there are many styles of roles/permissions and each app will have their own.

### Deployment

This application is set up to deploy heroku and via ansible to a VPS. When initially templating the application, you can clear out the deployment option that we're not using.

#### Ansible

Ansible deployment is only configured for Vagrant deployment.

If we're not using ansible, delete the following:

```bash
rm -r ./deploy ./ansible.cfg ./Vagrantfile ./release.sh
```

If we're using ansible, run the following to template for the new application:

```bash
git mv deploy/files/stein_example.local.env deploy/files/my_app.local.env
git mv deploy/files/stein_example.service deploy/files/my_app.service
```

Update the `git_repo` variable in `./bin/remote`

#### Heroku

If we're not using heroku, delete the following:

```bash
rm ./phoenix_static_buildpack.config ./elixir_buildpack.config
```

## Deployment

### Ansible Deployment

Install [Vagrant](https://www.vagrantup.com/), [VirtualBox](https://www.virtualbox.org/), and [Ansible](https://www.ansible.com/).

```bash
ansible-galaxy install -r deploy/requirements.yml
vagrant up
ansible-playbook -l local deploy/setup.yml
ansible-playbook -l local deploy/deploy.yml
```

The `setup.yml` playbook installs and configures common components (ssh, ntp, firewall, traefik, postgresql) and the `deploy` user.

The `deploy.yml` playbook generates a local release, copies it over to the application server, migrates, and restarts the application. This is in a similar setup to capistrano with release folders.

In order to connect to a running service, connect via the `remote.sh` script:

```bash
./bin/remote local iex
```

If you want to run a release task manually, ssh in as `deploy`:

```bash
export $(cat /etc/stein_example.env | xargs)
cd apps/stein_example/current
./bin/stein_example eval "SteinExample.ReleaseTasks.Migrate.run()"
```

To seed on staging:

```bash
export $(cat /etc/stein_example.env | xargs)
cd apps/stein_example/current
./bin/stein_example eval "SteinExample.ReleaseTasks.Seeds.run()"
```

#### Remote Script

To help facilitate remote debugging, we have a script to start a remote IEx or psql session.

```bash
# To start a bash session
./bin/remote production bash

# To start an IEx session
./bin/remote production iex

# To start a psql session
./bin/remote production psql
```

See `./bin/remote` for more of what it can do, as that help is more up to date.

### Docker locally

Docker is set up as a replication of production. This generates an erlang release and is not intended for development purposes.

```bash
docker-compose pull
docker-compose build
docker-compose up -d postgres
docker-compose run --rm app eval "SteinExample.ReleaseTasks.Migrate.run()"
docker-compose run --rm app eval "SteinExample.ReleaseTasks.Seeds.run()"
docker-compose up app
```

You now can view `http://localhost:4000` and access the application.

### Heroku

Buildpacks required:

- https://github.com/HashNuke/heroku-buildpack-elixir.git
- https://github.com/gjaldon/heroku-buildpack-phoenix-static.git
- https://github.com/oestrich/heroku-buildpack-elixir-mix-release.git

To migrate on heroku:

```bash
heroku run 'stein_example eval "SteinExample.ReleaseTasks.Migrate.run()"'
```

## Metrics

A metric server will start on `http://localhost:4021/metrics`, set up for [Prometheus](https://prometheus.io/) scraping.

If deploying via Heroku, you should remove the metric server config and host it via the `PromEx.Plug` through `Web.Endpoint`.

If deploying via ansible, then port `4021` should be accessible via our metrics server.

### Dashboards

By default PromEx is not configured to upload dashboards to Grafana. For local development or the first time setting up dashboards on our metrics server, you can use the following ENV to confiugre PromEx to upload dashboards.

```bash
GRAFANA_API_TOKEN=api-token-that-is-an-editor
GRAFANA_URL=http://localhost:3000
GRAFANA_UPLOAD_DASHBOARDS=true
GRAFANA_DATASOURCE_ID=datasource-id-for-prometheus
```

Afterwards on boot PromEx will upload the configured dashboards to the Grafana server.

### Prometheus Job

To configure our Prometheus to scrape the server, setup a new file config similar to below. Make sure to update `client`, `product`, and `datacenter` with the appropriate label values.

```json
[
  {
    "targets" : [
      "ip:4021"
    ],
    "labels" : {
      "job" : "app",
      "client" : "product",
      "datacenter" : "aws-us-east",
      "product" : "product",
      "environment" : "staging"
    }
  },
  {
    "targets" : [
      "ip:4021",
      "ip:4021"
    ],
    "labels" : {
      "job" : "app",
      "client" : "client",
      "datacenter" : "aws-us-east",
      "product" : "product",
      "environment" : "production"
    }
  }
]
```
