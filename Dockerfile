FROM ruby

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

ENV PORT 8080
CMD ["sh", "-c", "exec bundle exec rackup -p $PORT -o 0.0.0.0 config.ru"]
