FROM haskell:latest

WORKDIR /app

# Install system dependencies that sqlite-simple commonly needs
RUN apt-get update && apt-get install -y --no-install-recommends \
    libsqlite3-dev \
    pkg-config \
 && rm -rf /var/lib/apt/lists/*

# Install the same Haskell libraries already used in the repo/dev workflow
RUN cabal update && \
    cabal install --lib \
      scotty wai-extra random text \
      aeson sqlite-simple http-types warp

# Copy repository contents
COPY . .

# Compile the SQLite example as the deployed service
RUN ghc -O2 \
    -package scotty \
    -package wai-extra \
    -package random \
    -package text \
    -package aeson \
    -package sqlite-simple \
    -package http-types \
    -package warp \
    src/04-scotty-sqlite/sqliteScotty.hs \
    -o server

CMD ["./server"]