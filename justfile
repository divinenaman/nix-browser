export NIX_BROWSER_NO_OPEN := "true"

default:
    @just --list 

# Auto-format the source tree
fmt:
    treefmt

alias f := fmt

# Run the project locally
watch $RUST_BACKTRACE="1":
    cargo leptos watch

alias w := watch

# Run tests (backend & frontend)
test:
    cargo test
    cargo leptos test

# Run tests (e2e-playwright)
e2e-playwright-test:
    nix run .#e2e-playwright-test

# Run e3e tests against `just watch` server
e2e:
    cd e2e-playwright && TEST_PORT=3000 playwright test --project chromium

# Run docs server (live reloading)
doc:
    cargo-doc-live

# Run CI locally
ci:
    nixci

# Setup node_modules using Nix (invoked automatically by nix-shell)
node_modules NODE_PATH:
    rm -rf ./e2e-playwright/node_modules
    echo ${NODE_PATH}
    # For some reason, symlinking is not enough.
    # ln -sf ${NODE_PATH} ./e2e-playwright/node_modules
    cp -r ${NODE_PATH} ./e2e-playwright/node_modules
    chmod -R u+w ./e2e-playwright/node_modules
