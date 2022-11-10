FROM node:16-alpine as builder
WORKDIR '/app'
COPY package*.json ./
RUN npm install
# We won't change our files in production environment. Thus we can just copy
# our files directly into the image without specifying any volumes or something.
COPY . .
RUN npm run build

# This build copy the files into WORKDIR. Thus all the files we care about
# will be inside /app/build, which will be copied over during the Run Phase.

FROM nginx
# Without EXPOSE parameter, the environment worked successfully.
# EXPOSE 80
COPY --from=builder /app/build /usr/share/nginx/html
# How do we know where we should copy the files for nginx?
# See the "Hosting some simple static content" title on Docker Hub
# https://hub.docker.com/_/nginx

# We don't have to specify the command for this nginx container because
# the default command is to start the nginx server already.