# Integrate PyTorch AI services with semantic.works

All the goods of [the python template](https://github.com/mu-python-template), with added support for [PyTorch](https://pytorch.org).

This service is a good starting point to build semantic PyTorch services.  Because this service is an extension, all documentation of the mu-python-template also holds.

## How to

### Base a service on this template

Everything is handled using the `ONBUILD` statement of the parent image.  Therefore you only need to set the parent image and the maintainer in the Dockerfile; and create a top-level web.py for answering requests.

See [mu-python-template](https://github.com/mu-semtech/mu-python-template#quickstart) for up to date information.

`Dockerfile`

    FROM lblod/mu-python-pytorch-template
    LABEL maintainer="Aad Versteden <aad@redpencil.io>"

`web.py`

    @app.route("/hello")
    def hello():
        return "Hello from the mu-python-template!"

### Adding python libraries and running Python during build

#### Use of requirements.txt

To add a python library, add it to the `requirements.txt` file.  It will be picked up on build and the download will be cached.

`requirements.txt`

    transformers
    sentencepiece

Once you rebuild the Docker container the new dependencies will be downloaded.  Note that although the live reload feature during development should pick up changed files, it may not pick up changes in the `requirements.txt`.  Start and stop manually to be sure.

#### Use of setup.py

Some common constructs download and cache a model on first use.  It is good practice to embed the model inside of the Docker container so there are no external dependencies after build.  Models are considered application data and should be stored in the `/data` folder of the service.

The setup.py file is loaded after the requirements.txt have been installed and the result is cached.  This will therefore survive automatic reloads or subsequent docker builds provided intermediate layers are not thrown away.

`setup.py`

    from transformers import MarianMTModel, MarianTokenizer

    tokenizer = MarianTokenizer.from_pretrained("Helsinki-NLP/opus-mt-nl-en")
    model = MarianMTModel.from_pretrained("Helsinki-NLP/opus-mt-nl-en", torch_dtype="auto")

    # save to /data
    tokenizer.save_pretrained("/data/tokenizer")
    model.save_pretrained("/data/model")

Based on the location of the model, you can load it on boot or when the first computation occurs.

## Discussion

### Why a separate template for pytorch?

The PyTorch dependency is a fairly heavy one.  It is nice to resue this image across systems.  The approach of creating a template specifically for this purpose also lets us experiment with features more important to AI services, which may later flow back to the mu-python-template.
