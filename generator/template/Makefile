DOCKER_IMAGE_NAME=<%= tag.split(':')[0] %>
BUILDX_PLATFORM=linux/amd64

main:
	@echo No action was performed.
	@echo
	@echo Available commands:
	@echo - build: build development docker image
	@echo - run: run development docker container

build:
	@echo Building development docker image
	@docker build --pull --rm \
		--build-arg NODE_ENV=development \
		-f "Dockerfile" -t ${DOCKER_IMAGE_NAME} .

buildx:
	@echo Building multi-arch docker image
	@docker buildx rm ${DOCKER_IMAGE_NAME}-builder || true
	@docker run --rm \
		--privileged tonistiigi/binfmt:latest \
		--install all
	@docker buildx create \
		--name ${DOCKER_IMAGE_NAME}-builder \
		--driver docker-container \
		--driver-opt image=moby/buildkit:v0.8-beta,network=host \
		--buildkitd-flags '--allow-insecure-entitlement security.insecure --allow-insecure-entitlement network.host' \
		--use
	@docker buildx inspect --bootstrap
	@docker buildx build \
		--build-arg NODE_ENV=development \
		--build-arg VUE_APP_VERSION=v0.0.6-alpha.5 \
		--build-arg VUE_APP_GIT_SHA=c71b9c6922bba5def8acd13a89cbce176375998f \
		--platform=${BUILDX_PLATFORM} \
		--tag ${DOCKER_IMAGE_NAME} \
		--load \
		--file ./Dockerfile .
	@docker buildx rm ${DOCKER_IMAGE_NAME}-builder

run:
	@echo Running development image on port http://localhost:8088
	@docker run -it --rm \
		--env-file .env.development \
		--publish 8088:80 \
		${DOCKER_IMAGE_NAME}

reset-snapshots:
	find test -type d -name "__snapshots__" -exec rm -rf "{}" \;
