FROM python:2.7
COPY . /OC.DOCS/
WORKDIR /OC.DOCS/
RUN pip install mkdocs
EXPOSE 8000
CMD ["mkdocs", "serve", "--dev-addr", "0.0.0.0:8000"]