FROM ruby:3.1.0

# Install apt based dependencies required to run Rails as
# well as RubyGems. As the Ruby image itself is based on a
# Debian image, we use apt-get to install those.
RUN apt-get update && apt-get install -y \
  build-essential \
  nodejs \
  npm

RUN npm i -g npx
RUN npm i npm-update-all -g

# Configure the main working directory. This is the base
# directory used in any further RUN, COPY, and ENTRYPOINT
# commands.
RUN mkdir -p /app
WORKDIR /app

# Copy the Gemfile as well as the Gemfile.lock and install
# the RubyGems. This is a separate step so the dependencies
# will be cached unless changes to one of those two files
# are made.
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
COPY Procfile.dev /app/Procfile.dev
RUN gem install foreman && gem install bundler && bundle install --jobs 20 --retry 5

COPY . /app
RUN rm -rf tmp/*

ADD . /app

CMD ["foreman", "start", "-f /app/Procfile.dev"]