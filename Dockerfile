from semtech/mu-python-template:feature-cache-pip-install

# Hack to only copy file if it exists
ONBUILD ADD Dockerfile requirement[s].txt /app/
ONBUILD RUN cd /app/ && if [ -f requirements.txt ]; then pip install -r requirements.txt; fi
# Hack to only copy file if it exists
ONBUILD ADD Dockerfile setu[p].py /app/
ONBUILD RUN cd /app/ && if [ -f setup.py ]; then python /app/setup.py; fi
ONBUILD ADD . /app/
