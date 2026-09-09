FROM nginx:alpine

COPY index.html /usr/share/nginx/html/index.html

EXPOSE 80

CMD ["/bin/sh", "-c", "sed -i \"s/ENVIRONMENT_PLACEHOLDER/${ENVIRONMENT}/g; s/BUILD_SHA_PLACEHOLDER/${BUILD_SHA}/g\" /usr/share/nginx/html/index.html && nginx -g 'daemon off;'"]