###########################################################
# Dockerfile to build RSEM container images
# Tool for making counts in the genomic analysis
# Based on Ubuntu
############################################################
#Build the image based on Ubuntu
FROM ubuntu:16.04

#Maintainer and author
MAINTAINER Magdalena Arnal <marnal@imim.es>

#Install required packages in ubuntu for STAR
RUN apt-get update && apt-get install -y \
    build-essential \
    gcc-multilib \
    apt-utils \
    git \
    libtbb-dev \
    wget \
    zlib1g-dev \
    python \
    perl \
    perl-base \
    r-base \
    r-base-core \
    r-base-dev

RUN rm -rf /var/lib/apt/lists/*

#Install STAR
WORKDIR /usr/local/
RUN git clone https://github.com/alexdobin/STAR.git
WORKDIR /usr/local/STAR/
RUN git checkout 2.5.4b
WORKDIR /usr/local/STAR/source
RUN make STAR
ENV PATH /usr/local/STAR/source:$PATH

#Install Bowtie2
WORKDIR /bin
RUN wget --default-page=bowtie2-2.3.4.1-linux-x86_64.zip http://sourceforge.net/projects/bowtie-bio/files/bowtie2/2.3.4.1/bowtie2-2.3.4.1-linux-x86_64.zip/
RUN unzip bowtie2-2.3.4.1-linux-x86_64.zip
RUN rm bowtie2-2.3.4.1-linux-x86_64.zip
#Add bowtie2 to the path variable
ENV PATH $PATH:/bin/bowtie2-2.3.4.1-linux-x86_64

#Install RSEM
WORKDIR /usr/local/
RUN git clone https://github.com/deweylab/RSEM.git
WORKDIR /usr/local/RSEM
RUN git checkout v1.2.28
RUN make
RUN make ebseq
ENV PATH /usr/local/RSEM:$PATH

#Cleanup
RUN apt-get clean
