FROM node:12.13-alpine As BUILD_IMAGE
LABEL image=http-proxy-server
WORKDIR /app
COPY . .
RUN npm i

ENV NODE_ENV=production
RUN npm run build

# remove all devDependencies packages 
RUN npm prune --production

# remove unused dependencies: RUN du -sh ./node_modules/* | sort -nr | grep '\dM.*'
RUN rm -rf /node_modules/typescript
RUN rm -rf /node_modules/eslint

FROM node:12.13-alpine as PRODUCTION
LABEL image=http-proxy-server
WORKDIR /usr/src/app
# copy from build image
COPY --from=BUILD_IMAGE /app/dist ./dist
COPY --from=BUILD_IMAGE /app/package*.json ./
COPY --from=BUILD_IMAGE /app/node_modules ./node_modules
CMD ["npm", "run", "start"]