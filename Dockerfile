FROM digitallyseamless/nodejs-bower-grunt
MAINTAINER Igor Goltsov <igor@ecomgems.com>

# Copy project files
# into container
ADD ./server /data/server
ADD ./template /data/template
ADD ./Gruntfile.coffee /data/
ADD ./package.json /data/
ADD ./node_modules /data/node_modules

# Remove file with
# dev environment
RUN rm /data/server/config/local.env.coffee

# Install Node dependencies
RUN npm install

# Create folder that
# required for start
RUN mkdir /data/certs

# Expose ports
EXPOSE 8080
EXPOSE 8443

CMD ["grunt", "serve:dist"]
