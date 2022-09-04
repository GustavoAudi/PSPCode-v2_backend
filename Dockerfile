# Dockerfile

FROM ruby:3.1.2
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
ADD . /myapp
WORKDIR /myapp
RUN bundle install

# Configure the main process to run when running the image
RUN bash -c "rm -f tmp/pids/server.pid"
ENTRYPOINT ["rails", "server", "-b", "0.0.0.0"]