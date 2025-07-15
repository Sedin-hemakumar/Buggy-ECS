FROM ruby-3.3.8v1  
# Set working directory
WORKDIR /app

# Install gems
COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install

# Copy project files
COPY . .

# Start the Rails server
CMD ["rails", "server", "-b", "0.0.0.0"]
