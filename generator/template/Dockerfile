# Build Stage 1
# Bootstrap docker image
#
FROM node:14-alpine AS builder

WORKDIR /usr/src/app
ENV CYPRESS_INSTALL_BINARY=0

COPY .config/bootstrap.sh /bootstrap.sh
RUN /bootstrap.sh

COPY .npmrc .yarnrc package.json ./
COPY yarn.lock ./
RUN yarn install

ARG NODE_ENV=production
ARG VUE_APP_VERSION=latest
ARG VUE_APP_GIT_SHA=${VUE_APP_VERSION}

ENV CI=true
ENV VUE_APP_VERSION=${VUE_APP_VERSION}
ENV VUE_APP_GIT_SHA=${VUE_APP_GIT_SHA}

COPY . ./
RUN yarn run build --mode ${NODE_ENV}

# Build Stage 2
# This build take the application built in the builder stage
#
FROM nginx:stable-alpine

ARG NODE_ENV=production
ARG VUE_APP_VERSION=latest
ARG VUE_APP_GIT_SHA=${VUE_APP_VERSION}

LABEL "com.soramitsukhmer.vendor"="Soramitsu Khmer"
LABEL maintainer="Soramitsu Khmer DevOps Engineer <devops@soramitsukhmer.com>"
LABEL environment="$NODE_ENV"
LABEL version="$VUE_APP_VERSION"
LABEL sha="$VUE_APP_GIT_SHA"

ENV APP_ENV=1
ENV VUE_APP_VERSION=${VUE_APP_VERSION}
ENV VUE_APP_GIT_SHA=${VUE_APP_GIT_SHA}

# NGINX
# Copy the respective configuration
COPY .config/docker-entrypoint.d/*.sh /docker-entrypoint.d/
COPY .config/nginx/templates/*.template /etc/nginx/templates/
COPY .config/nginx/nginxconfig.io /etc/nginx/nginxconfig.io

# Copy the application from builder stage
COPY --from=builder /usr/src/app/dist /var/www/public

# Health Check
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
    CMD curl -f http://localhost/actuator/health || exit 1

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
