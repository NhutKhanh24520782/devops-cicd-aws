# FROM node:20-alpine
# WORKDIR /app
# COPY package*.json ./
# RUN npm install --omit=dev
# COPY . .
# EXPOSE 5000
# CMD ["npm", "start"]


# FROM node:20-alpine

# WORKDIR /app

# ENV NODE_ENV=production

# COPY package*.json ./

# RUN npm ci --omit=dev

# COPY . .

# EXPOSE 5000

# USER node

# CMD ["npm", "start"]

FROM node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .

RUN npm run build

FROM node:20-alpine

WORKDIR /app

COPY package*.json ./
RUN npm ci --omit=dev

COPY --from=builder /app/dist ./dist

EXPOSE 5000

USER node

CMD ["node", "dist/main.js"]