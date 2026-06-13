FROM node:20-slim
WORKDIR /app

# Copy backend files
COPY backend/package*.json ./
COPY backend/src ./src
COPY backend/data ./data
COPY backend/railway.json ./

# Install dependencies
RUN npm ci --only=production

EXPOSE 8080

CMD ["node", "src/server.js"]
