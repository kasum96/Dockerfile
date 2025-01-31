# Build docker with
# docker build -t kinesis-video-producer-sdk-cpp-raspberry-pi .

FROM resin/rpi-raspbian:stretch

RUN apt-get update && \
	apt-get install -y \
	cmake \
	curl \
	g++ \
	gcc \
	git \
	gstreamer1.0-plugins-base-apps \
	gstreamer1.0-plugins-bad \
	gstreamer1.0-plugins-good \
	gstreamer1.0-plugins-ugly \
	gstreamer1.0-tools \
	gstreamer1.0-omx \
	libssl-dev \
	libcurl4-openssl-dev \
	liblog4cplus-dev \
	libgstreamer1.0-dev \
	libgstreamer-plugins-base1.0-dev \
	m4 \
	make \
	openssh-server \
	pkg-config \
	vim

#RUN curl -OL https://github.com/raspberrypi/firmware/archive/1.20180417.tar.gz
#RUN tar xvf 1.20180417.tar.gz
#RUN cp -r /opt/firmware-1.20180417/opt/vc ./
#RUN rm -rf firmware-1.20180417 1.20180417.tar.gz

###################################################
# create symlinks for libraries used by omxh264enc
###################################################

RUN     ln -s /opt/vc/lib/libopenmaxil.so /usr/lib/libopenmaxil.so && \
        ln -s /opt/vc/lib/libbcm_host.so /usr/lib/libbcm_host.so && \
        ln -s /opt/vc/lib/libvcos.so /usr/lib/libvcos.so &&  \
        ln -s /opt/vc/lib/libvchiq_arm.so /usr/lib/libvchiq_arm.so && \
        ln -s /opt/vc/lib/libbrcmGLESv2.so /usr/lib/libbrcmGLESv2.so && \
        ln -s /opt/vc/lib/libbrcmEGL.so /usr/lib/libbrcmEGL.so && \
        ln -s /opt/vc/lib/libGLESv2.so /usr/lib/libGLESv2.so && \
        ln -s /opt/vc/lib/libEGL.so /usr/lib/libEGL.so

WORKDIR /opt/
RUN	git clone https://github.com/awslabs/amazon-kinesis-video-streams-producer-sdk-cpp.git
WORKDIR /opt/amazon-kinesis-video-streams-producer-sdk-cpp/build/
RUN cmake .. -DBUILD_GSTREAMER_PLUGIN=ON -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON -DBUILD_OPENSSL_PLATFORM=linux-armv4 && \
	make

ENV LD_LIBRARY_PATH=/opt/amazon-kinesis-video-streams-producer-sdk-cpp/open-source/local/lib
ENV GST_PLUGIN_PATH=/opt/amazon-kinesis-video-streams-producer-sdk-cpp/build/:$GST_PLUGIN_PATH
