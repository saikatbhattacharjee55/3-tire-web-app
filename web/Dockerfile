FROM node:20-alpine

WORKDIR /app

# Copy dependency files first for Docker layer caching
COPY --chown=node:node package*.json ./

# Install production dependencies
RUN npm install --omit=dev

# Copy application source
COPY --chown=node:node . .

# Run as non-root user
USER node

EXPOSE 3000

CMD ["npm", "start"]