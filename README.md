# homelab

Docker Compose stacks, one directory each under `stacks/`.

    bin/init-env <stack>           # create .env from .env.example, generating secrets
    $EDITOR stacks/<stack>/.env    # fill in anything left blank
    cd stacks/<stack> && docker compose up -d

`.env` files and `data/` are gitignored; only `.env.example` templates are committed.
