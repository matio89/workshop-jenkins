# Build the front end component in our angular front end base image
FROM gmc-angular-front-base:latest as front-base

COPY . .

RUN npm run build

# Create image based off of the nginx image
FROM nginx:1.13.12-alpine

COPY --from=front-base /usr/src/app/dist /usr/share/nginx/html

COPY ./nginx.conf /etc/nginx/conf.d/default.conf
