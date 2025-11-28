# Gunakan base image Node.js LTS
FROM node:20-alpine AS builder

WORKDIR /app

# Copy package.json dan lock file
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy semua source code
COPY . .

# Build Next.js untuk production
RUN npm run build

# Stage kedua: hanya copy hasil build
FROM node:20-alpine AS runner
WORKDIR /app

ENV NODE_ENV=production

# Copy package.json untuk npm start
COPY package*.json ./

# Install hanya dependencies production
RUN npm install --omit=dev

# Copy hasil build dari stage builder
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public

EXPOSE 3000

CMD ["npm", "start"]
