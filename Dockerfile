FROM hyperized/scratch:latest as trigger
# Used to trigger Docker hubs auto build, which it wont do on the official images

FROM ruby:2.5

LABEL maintainer="Gerben Geijteman <gerben@hyperized.net>"
LABEL description="A base installation for Redmine"

ARG redmine_version=4.0.0

# Ensure everything is up to date.
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get dist-upgrade -y && \
    apt-get install -y wget unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN adduser --disabled-password --gecos "Redmine" redmine
USER redmine
WORKDIR /home/redmine

# Install Redmine
RUN wget http://www.redmine.org/releases/redmine-$redmine_version.zip && \
    unzip redmine-$redmine_version.zip

WORKDIR /home/redmine/redmine-$redmine_version

# Install required bundles
RUN gem install bundler && \
    bundle install --without development test

ENTRYPOINT ["ruby", "bin/rails", "server", "-b", "0.0.0.0", "webrick", "-e", "production"]
