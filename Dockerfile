FROM python:3.6

COPY . /app

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" >/etc/apt/sources.list.d/yarn.list && \
    apt-get update  && \
    apt-get install -y build-essential nodejs yarn && \
    adduser --disabled-password --gecos "" buza && \
    chown buza:buza -R /app

USER buza

WORKDIR /app

ENV PATH="/home/buza/.local/bin:${PATH}"

RUN pip3 install --user pipenv && \
    cd /app && \
    yarn && \
    cp -p .env.example .env && \
    pipenv install --dev && \
    pipenv run django-admin migrate && \
    pipenv run django-admin loaddata examples/example-data.json

EXPOSE 8000
