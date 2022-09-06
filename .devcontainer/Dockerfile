# git-sizer staging build
FROM golang:alpine AS git-sizer-build-env
RUN apk add --no-cache git
RUN go get github.com/github/git-sizer

# git filter-repo and git install
FROM alpine:latest
RUN apk add --update --no-cache git python3 && ln -sf python3 /usr/bin/python
RUN python3 -m ensurepip
RUN pip3 install --no-cache --upgrade pip setuptools
RUN pip3 install git-filter-repo
WORKDIR /source
RUN git clone --bare https://github.com/torvalds/linux
# Attempting to modify linux
RUN cd /source/linux
RUN git checkout -b temp 5489377ce40d

COPY --from=git-sizer-build-env /go/bin/git-sizer /usr/bin/git-sizer