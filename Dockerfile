# STEP 1: Angular build
FROM node:20-alpine as build

WORKDIR /app

COPY ./app/package*.json ./
RUN npm install

COPY ./app ./

RUN npm run production

# STEP 2: Nginx serving
FROM nginx:alpine

# Remove default nginx content
RUN rm -rf /usr/share/nginx/html/*

# Copy built Angular app
COPY --from=build /app/dist/app/browser /usr/share/nginx/html

# Configure Nginx for Angular SPA
COPY ./nginx/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
