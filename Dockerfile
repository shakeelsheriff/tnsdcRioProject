# Base image
FROM debian:buster

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

# Install Xvfb and other necessary packages
RUN apt-get install -y xvfb dbus-x11 x11-utils

# Download Eclipse
RUN curl -L -o eclipse.tar.gz "https://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/2021-12/R/eclipse-jee-2021-12-R-linux-gtk-x86_64.tar.gz" \
    && tar -xzvf eclipse.tar.gz -C /opt \
    && rm eclipse.tar.gz

# Set the PATH for Eclipse
ENV PATH="${PATH}:/opt/eclipse"

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

# Install Firefox ESR
RUN apt-get install -y firefox-esr

# Download and configure Gecko driver
RUN curl -L -o geckodriver-v0.30.0-linux64.tar.gz https://github.com/mozilla/geckodriver/releases/download/v0.30.0/geckodriver-v0.30.0-linux64.tar.gz \
    && tar -xzvf geckodriver-v0.30.0-linux64.tar.gz -C /usr/local/bin/ \
    && chmod +x /usr/local/bin/geckodriver

# Expose necessary ports for Jenkins, Tomcat, and Xvfb
EXPOSE 8081 80 5901

# Set working directory
WORKDIR /app

# Start Xvfb, Jenkins, Tomcat, and Eclipse with GUI
CMD ["sh", "-c", "Xvfb :1 -screen 0 1024x768x24 & service jenkins start && tail -f /var/log/jenkins/jenkins.log & $CATALINA_HOME/bin/catalina.sh run & export DISPLAY=:1 && /opt/eclipse/eclipse -data /workspace"]
