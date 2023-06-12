FROM cimg/python:3.7.17-browsers
MAINTAINER Etienne Tétreault-Pinard "code@etpinard.xyz"

RUN sudo apt-get update \
 && sudo apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false

RUN cd /usr/local/src \
 && sudo mkdir /usr/local/src/julia \
 && sudo curl -o julia.tar.gz --location --show-error \
 https://julialang-s3.julialang.org/bin/linux/x64/1.9/julia-1.9.1-linux-x86_64.tar.gz \
 && sudo tar --extract --gzip --strip 1 --directory=/usr/local/src/julia --file=julia.tar.gz \
 && sudo ln -s /usr/local/src/julia/bin/julia /usr/local/bin/julia
