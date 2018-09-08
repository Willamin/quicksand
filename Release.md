# Release

- Testing
- Bundling
- Shipping
- Caveats

## Testing

Before releasing, Quicksand must be tested. Currently this must be done manually. See Testing.md for more details.

## Bundling

Quicksand's release process uses the Releaser tool by Will Lewis. This bumps the version in shard.yml, tags the commit, builds the app, and pushes tags.

```shell
$ cd quicksand
$ releaser x.y.z
```

## Shipping

Releaser will add an archive to the `releases` directory. To ship a release, edit the tag on Github, and just drag-n-drop the archive to the tag. 

## Caveats

Currently, Releaser only builds and bundles the app for the system it's run on. Consequently, that's how Quicksand will be released _for the time being_. I'll be running Releaser on macOS, so I'll only be providing prebuilt binaries for macOS.