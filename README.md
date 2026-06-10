# A Simple Mac Container Filesystem Performance Benchmark

This benchmark is a simple test of bind filesystem performance, done because I've found container filesystems to be consistently slow on Mac OS, which has prevented me from using them regularly.

![chart comparing results](docs/static/chart.png)

The process is:

- make sure npm has a cold cache
- run `npm install`, either natively or in a container with a bind mount

The versions under test here are:

| software  | version                                                                            |
| :-------- | :--------------------------------------------------------------------------------- |
| node      | v24.16.0                                                                           |
| npm       | 11.13.0                                                                            |
| container | container CLI version 1.0.0 (build: release, commit: ee848e3)                      |
| orb       | Version: 2.2.1 (2020100) Commit: 0e182b501fcd9e05b99ffb363fce03610390c400 (v2.2.1) |
| colima    | colima version 0.10.3                                                              |
| hyperfine | hyperfine 1.20.0                                                                   |

I'm using the `node:24.16.0-slim` image available as of jun 10

## Environments

| Environment            | Description                                                               |
| :--------------------- | :------------------------------------------------------------------------ |
| **Native (host)**      | `npm install` directly on macOS (Apple Silicon), cold cache               |
| **OrbStack**           | `docker run` via OrbStack, volume mount                                   |
| **Apple Container**    | `container run` with `-v` volume mount (Apple's native container runtime) |
| **Colima vz+virtiofs** | `docker run` via Colima using the `vz` VM backend + `virtiofs` mount type |

All container tests mount the project directory as a volume, so `node_modules` is written across the virtualization boundary.

## Results

![chart comparing results](docs/static/chart.png)

all times in seconds. Test was done on a macbook m2 max with 32gb of memory, connected to power

| Test            | mean   | stdev  | min    | max     | ratio       |
| :-------------- | :----- | :----- | :----- | :------ | :---------- |
| native          | 37.692 | 5.095  | 31.144 | 42.718  | 1           |
| orbstack        | 37.815 | 2.344  | 34.054 | 39.667  | 1.00 ± 0.15 |
| apple container | 62.843 | 7.504  | 52.913 | 71.785  | 1.67 ± 0.30 |
| colima          | 89.014 | 12.939 | 77.455 | 109.065 | 2.36 ± 0.47 |

Sometimes, orbstack actually _beats_ native performance, which I don't actually understand. Every time, it's been within the margin of error compared to native, which is very imporessive.

Apple `container` is slower, and colima slower still.

I had not previously used `orbstack`, and was only prompted to by a developer asking me about it on news.yc; I may be checking into it more.

## Reproducing

```bash
mise install

# Start all runtimes
colima start --vm-type vz --mount-type virtiofs
container system start
# OrbStack: install from https://orbstack.dev and start the app

# Pull the node image into each runtime
docker --context colima pull node:24.16.0-slim
docker --context orbstack pull node:24.16.0-slim
container image pull node:24.16.0-slim

# Run benchmarks
bash run-benchmark.sh
```

## Why this benchmark sucks

I made `npm install` the benchmark because it's an extremely common thing I do when working with code, and it shows a pain point for container usage in my experience on mac: working with lots of files is very slow.

This has made it painful for me to try and use containerized solutions for local dev on macs in javascript/typescript, python, and rust, all of which depend on a large number of files living in something like a `node_modules` folder.

However, this benchmark relies on the network. It was run on my computer while I browsed the internet. It was run on a computer that has lots of other services running on it.

You should take these results with a bucket full of salt!

The results for apple's container and colima both align with my experiences, and I would expect docker desktop to have similar results.

## You did this wrong

Please file an issue if you have an idea for how I can do it better! PRs and issues are welcomed. I'm available on [bsky](https://bsky.app/profile/billmill.org), [masto](https://hachyderm.io/@llimllib) and [email](mailto:bill@billmill.org)
