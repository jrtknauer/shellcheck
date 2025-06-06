FROM ubuntu:24.04 AS build

ARG SHELLCHECK_VERSION
ENV SHELLCHECK_VERSION=${SHELLCHECK_VERSION:-v0.10.0}

WORKDIR /build

RUN <<EOF
apt-get update
apt-get \
	--no-install-recommends \
	--quiet \
	--yes \
	install \
	cabal-install \
	git
rm --force --recursive /var/lib/apt/lists/*
EOF

COPY . .

RUN <<EOF
git switch $SHELLCHECK_VERSION
cabal update
cabal install
EOF

FROM scratch AS output

COPY --from=build /.cabal/bin /

ENTRYPOINT ["/"]
