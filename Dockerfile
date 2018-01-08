FROM python:3-alpine

LABEL maintainer Knut Ahlers <knut@ahlers.me>

ADD requirements.txt /tmp/requirements.txt

RUN set -ex \
 && pip install -r /tmp/requirements.txt \
 && adduser -D -s /bin/bash -h /home/curator -g curator curator

USER curator

VOLUME ["/home/curator/.curator", "/data"]

ENTRYPOINT ["/usr/local/bin/curator"]
CMD ["--help"]
