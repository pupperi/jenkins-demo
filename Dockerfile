FROM nginx
COPY static-html-directory /usr/share/nginx/html

CMD ["app"]
EXPOSE 8080
