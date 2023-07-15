# Base image
FROM ubuntu:latest

# Install utilities
RUN apt-get update && \
    apt-get install -y git vim build-essential curl

# Install OpenJDK
RUN apt-get install -y openjdk-11-jdk

# Set environment variables for OpenJDK
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV PATH=$PATH:$JAVA_HOME/bin

# Install curl
RUN apt-get install -y curl

RUN apt-get install -y xvfb

# Download Eclipse
RUN curl -L -o eclipse.tar.gz "https://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/2021-12/R/eclipse-jee-2021-12-R-linux-gtk-x86_64.tar.gz" \
    && tar -xzvf eclipse.tar.gz -C /opt \
    && rm eclipse.tar.gz

# Set the PATH for Eclipse
ENV PATH="${PATH}:/opt/eclipse"

# Install required packages for GUI
RUN apt-get install -y dbus-x11 x11-utils

# Set up X11 forwarding
ENV DISPLAY=:0

# Install Apache Tomcat
RUN apt-get install -y tomcat9

# Expose default ports for Apache Tomcat
EXPOSE 8082

# Set environment variables for Apache Tomcat
ENV CATALINA_HOME=/usr/share/tomcat9
ENV PATH=$PATH:$CATALINA_HOME/bin

# Install Jenkins with public key
RUN apt-get update && \
    apt-get install -y gnupg2 wget && \
    wget -q -O /tmp/jenkins.io.key https://pkg.jenkins.io/debian/jenkins.io.key && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 5BA31D57EF5975CA && \
    apt-key add /tmp/jenkins.io.key && \
    echo "deb https://pkg.jenkins.io/debian-stable binary/" | tee /etc/apt/sources.list.d/jenkins.list && \
    apt-get update && \
    apt-get install -y jenkins && \
    systemctl enable jenkins

# Install GIT and Maven
RUN apt-get install -y git maven

# Install Chromium driver
RUN apt-get install -y chromium-driver

# Install Gecko driver (Firefox)
RUN apt-get install -y firefox

# Download and configure Gecko driver
RUN wget -O /tmp/geckodriver-v0.30.0-linux64.tar.gz https://github.com/mozilla/geckodriver/releases/download/v0.30.0/geckodriver-v0.30.0-linux64.tar.gz && \
    tar -xvzf /tmp/geckodriver-v0.30.0-linux64.tar.gz -C /usr/local/bin/ && \
    chmod +x /usr/local/bin/geckodriver

# Expose necessary ports for Jenkins
EXPOSE 8081 80 5902

# Set working directory
WORKDIR /app

# Start Jenkins, Tomcat, and Eclipse with GUI
CMD service jenkins start && tail -f /var/log/jenkins/jenkins.log & \
    $CATALINA_HOME/bin/catalina.sh run & \
    /usr/bin/Xvfb :1 -screen 0 1024x768x24 & \
    export DISPLAY=:1 && /opt/eclipse/eclipse -data /workspace
