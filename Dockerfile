FROM node:23

# Install necessary packages including tzdata for timezone setting
RUN apt-get update && apt-get install -y \
    build-essential \
    libnode108 \
    nodejs \
    python3 \
    sqlite3 \
    libsqlite3-dev \
    make \
    node-gyp \
    g++ \
    tzdata && \
    rm -rf /var/lib/apt/lists/*

# Set the timezone environment variable
ENV TZ=Etc/UTC

# Set the working directory
WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install && npm cache clean --force

# Copy the rest of the application code
COPY . .

# Ensure /app/uploads and /app/database have rw permissions
RUN mkdir -p /app/uploads /app/database && \
    chmod -R 777 /app/uploads /app/database

# Build the application
RUN npm run build

# Argument for the port
ARG PORT=3000
# Set the environment variable for the port
ENV PORT=$PORT

# Expose the application port
EXPOSE $PORT

# Set the command to run the application
CMD ["node", "main"]