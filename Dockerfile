FROM node:10 AS server-build
WORKDIR /root/
COPY api/package*.json ./api/
RUN cd api && npm install
COPY api/server.js ./api/

EXPOSE 80

CMD ["node", "./api/server.js"]