FROM ruby:3.2.2

RUN apt update -qq && apt install -y --no-install-recommends vim

ENV LANG=C.UTF-8

WORKDIR /app
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install # rails new が終わったら削除する

COPY containers/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
