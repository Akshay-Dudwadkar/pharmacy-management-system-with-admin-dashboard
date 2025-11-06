# Build stage
FROM node:20-alpine AS build
WORKDIR /app
# install app dependencies

COPY package*.json ./
RUN npm ci
COPY . .
# run build if defined (will no-op if no build script)
RUN npm run build --if-present

# Production stage
FROM node:20-alpine AS production
WORKDIR /app
ENV NODE_ENV=production

# copy app (including any build artifacts) from build stage
COPY --from=build /app ./

# remove builder node_modules and install only production deps
RUN rm -rf node_modules && npm ci --only=production

EXPOSE 3000
CMD ["npm", "start"]