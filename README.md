# luzifer-docker / curator

Run elasticsearch curator in a Docker container

## Usage

```bash
## Build container (optional)
$ docker build -t luzifer/curator .

## Create config and action file
$ tree
.
├── curator.yml
└── delete-indices.yml

0 directories, 2 files

## Execute curator
$ docker run --rm -ti -v $(pwd):/home/curator/.curator -v $(pwd):/data luzifer/curator /data/delete-indices.yml
```
