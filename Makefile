build:
	docker build -t spyserver -f Dockerfile --build-arg TARGETPLATFORM=linux/amd64 .

run:
	docker run -it --rm \
	-e LIST_IN_DIRECTORY=0 \
	spyserver

buildx:
	docker buildx build --platform linux/arm/v7,linux/amd64 -t zefie/spyserver --push .

.PHONY: build
