# Base image
FROM eclipse/che-server:nightly

# Set working directory
WORKDIR /projects

# Expose necessary ports for Eclipse Che
EXPOSE 8082 8083

# Start Eclipse Che server
CMD ["start"]
