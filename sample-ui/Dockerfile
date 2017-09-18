FROM ruby:2.2.4
MAINTAINER Joseph D Marhee <joseph@marhee.me>

ADD app/Gemfile /root/Gemfile
ADD app/app.rb /root/app.rb
ADD app/views/index.erb /root/views/index.erb

WORKDIR /root
RUN bundle install

ENTRYPOINT ruby app.rb -o 0.0.0.0
CMD []
