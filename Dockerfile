FROM debian:bookworm-backports

# apksigner is required by modern APK packages.
# This is shipped inside the build-tools package as part of the Android SDK.
# To enable apksigner, we need to install build-tools.
# This specifies the build-tools version to install at image build time.
# See: https://developer.android.com/tools/releases/build-tools
ARG BUILD_TOOLS_VERSION='34.0.0'

# Define environment variables.
# These can be redefined at run time.
ENV FDROID_REPO_NAME='F-Droid Repository'
ENV FDROID_REPO_ICON='fdroid.svg'
ENV FDROID_REPO_DESCRIPTION='Application repository for Android devices, powered by F-Droid.'
ENV FDROID_REPO_URL='http://localhost'
ENV FDROID_UPDATE_INTERVAL=12h

# Install system packages
RUN apt-get update && \
  apt-get -y install \
		androguard/bookworm-backports \
    apksigner
    curl \
		fdroidserver \
		sdkmanager/bookworm-backports \

# Install build-tools using sdkmanager.
RUN sdkmanager "build-tools;$BUILD_TOOLS_VERSION"

# Set default working directory.
RUN mkdir -p /fdroid
WORKDIR /fdroid

# Copy files over to the image.
COPY ./root/ /

# Make scripts executable.
RUN chmod +x /usr/local/bin/*

ENTRYPOINT ["bash", "/usr/local/bin/autorefresh"]
