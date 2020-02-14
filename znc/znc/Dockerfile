FROM znc:latest

RUN cd /home/znc &&\
    wget https://github.com/jreese/znc-push/archive/master.zip -O znc-push-master.zip &&\
    unzip znc-push-master.zip &&\
    cd znc-push-master &&\
    PATH=$PATH:/opt/znc/bin make && \
    cp push.so /opt/znc/lib64/znc/ &&\
    cd .. &&\
    rm -rf ./znc-push*
