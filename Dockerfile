# Base image for Ruby 3.1.0
FROM ruby:3.1.0

# Set working directory
WORKDIR /app

# Install dependencies
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libpq-dev \
    nodejs \
    yarn

# Install Bundler
RUN gem install bundler -v '2.6.3'

# Copy Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install gems for development and test
RUN bundle install

# Copy application code
COPY . .

# Expose port
EXPOSE 3000

# Start Rails server in development mode
CMD ["rails", "server", "-b", "0.0.0.0"]
