FROM baileyjm02/markdown-to-pdf:latest

COPY publish.sh /publish.sh
RUN chmod +x publish.sh

ENTRYPOINT ["/publish.sh"]
