FROM ruby:3.1.2

RUN ["gem", "install", "bundler", "-v", "2.5.6"]

WORKDIR /find_route

COPY . /find_route

RUN ["bundle", "install"]

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
