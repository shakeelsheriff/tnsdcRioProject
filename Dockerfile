# Base image
FROM eclipse/che-server:nightly

# Set working directory
WORKDIR /projects

# Expose necessary ports for Eclipse Che
EXPOSE 8080 8081

# Start Eclipse Che server
CMD ["start"]
