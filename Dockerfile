FROM ruby:2.5
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
RUN mkdir /todo-gamified-backend
WORKDIR /todo-gamified-backend
COPY Gemfile /todo-gamified-backend/Gemfile
COPY Gemfile.lock /todo-gamified-backend/Gemfile.lock
RUN bundle install
COPY . /todo-gamified-backend

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]