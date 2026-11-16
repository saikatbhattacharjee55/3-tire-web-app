FROM node:20-alpine

WORKDIR /app

# Copy package files first for better Docker layer caching
COPY package*.json ./

# Install production dependencies
RUN npm install --omit=dev

# Copy application source
COPY . .

# Make the application owned by the non-root node user
RUN chown -R node:node /app

# Switch to non-root user
USER node

EXPOSE 3000

CMD ["npm", "start"]