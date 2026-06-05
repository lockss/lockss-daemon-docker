## Introduction
This is project is the containerization of the 1.x LOCKSS daemon.

## Usage
1. Clone the `lockss-daemon-docker` repository:

    ```
    git clone https://github.com/lockss/lockss-daemon-docker
    ```

2. Create your local `.env` from the template and edit it to suit the host:

    ```
    cp examples/env.example .env
    $EDITOR .env
    ```

   `.env` is gitignored — it holds host-specific paths and the PostgreSQL
   password. (Docker Compose auto-loads it for both `${VAR}` substitution in
   `compose.yaml` and as the `env_file:` source for both containers.)

3. Build the `lockss/lockss-daemon` Docker image. Either:

    ```
    docker compose build
    ```

   or the equivalent helper script:

    ```
    bin/build
    ```

4. Start the containers (LOCKSS daemon and PostgreSQL):

    ```
    docker compose up -d
    ```

## Configuration
Three files control how the LOCKSS daemon runs:

1. `/etc/lockss/config.dat` (or wherever `LOCKSS_CONFIG_FILE` in `.env`
   points): The LOCKSS daemon configuration. This file should already
   exist if you had a previous installation of the LOCKSS daemon. If
   this is the first time installing LOCKSS on this host, use
   `bin/hostconfig` and follow its prompts to generate a `config.dat`.
   See `examples/config.dat.example` for a sample.

   **On an upgrade host**, the daemon's DB connection settings in
   `config.dat` must point at the bundled `postgres` sidecar — host
   `postgres` (resolved by Docker's internal DNS), database `LOCKSS`,
   user `LOCKSS`, password matching `POSTGRES_PASSWORD` in `.env`. If
   the legacy `config.dat` points at a different DB host or uses
   different credentials, update it before starting the stack.

2. `compose.yaml`: The Docker Compose file defining the `lockss` and
   `postgres` services. Host-specific paths and the PostgreSQL password
   are parameterized — edit values in `.env`, not in this file.

3. `.env`: Local-only environment file (copy from `examples/env.example`).
   The example's path defaults already point at the standard locations
   used by prior v1.x LOCKSS installations, so on an upgrade host you
   typically only need to set `POSTGRES_PASSWORD`. Keys:

    | Key                  | Purpose                                          |
    | -------------------- | ------------------------------------------------ |
    | `UID` / `GID`        | Numeric uid/gid for the `lockss` user/group      |
    | `POSTGRES_PASSWORD`  | Password for the `LOCKSS` postgres role          |
    | `LOCKSS_CONFIG_FILE` | Host path to `config.dat`                        |
    | `LOCKSS_KEYS_DIR`    | Host path to the LOCKSS keys directory           |
    | `LOCKSS_DATA_DIR`    | Host path to the LOCKSS data directory           |
    | `LOCKSS_LOG_DIR`     | Host path to the LOCKSS log directory            |

   **Path values must be explicit.** Relative paths must start with `./`
   (e.g. `./data`) and absolute paths with `/` (e.g. `/var/lockss/data`).
   A bare value starting with an alphanumeric character (e.g. `data`) is
   interpreted by Docker Compose as a *named volume*, not a host path,
   and the daemon will not see your existing files.
