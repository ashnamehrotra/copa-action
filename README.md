# Copacetic Action

[Marketplace](https://github.com/marketplace/actions/copacetic-action)

This action patches vulnerable containers using [Copa](https://github.com/project-copacetic/copacetic).
Copacetic Action is supported with Copa version 0.3.0 and later.

## Inputs

| Name               | Type   | Required | Default   | Description                                            |
| ------------------ | ------ | -------- | --------- | ------------------------------------------------------ |
| `image`            | String | True     |           | Image reference to patch                               |
| `image-report`     | String | True     |           | Trivy JSON vulnerability report of the image to patch  |
| `patched-tag`      | String | True     |           | Patched image tag                                      |
| `timeout`          | String | False    | `5m`      | Timeout for `copa patch`                               |
| `buildkit-version` | String | False    | `latest`  | Buildkit version                                       |
| `copa-version`     | String | False    | `latest`  | Copa version                                           |
| `output`           | String | False    |           | Output filename (available with copa v0.5.0 and later) |
| `format`           | String | False    | `openvex` | Output format (available with copa v0.5.0 and later)   |

## Outputs

| Name            | Type   | Description                          |
| --------------- | ------ | ------------------------------------ |
| `patched-image` | String | Image reference of the patched image |

## Example usage

https://github.com/project-copacetic/copa-action/blob/941743581b0da5e581ca5a575f9316228c2f6c00/.github/workflows/patch.yaml#L1-L77

**Patching Local Images** 
To scan and patch an image that is local-only (i.e. built or tagged locally but not pushed to a registry), `Copa` is limited to using `docker`'s built-in buildkit service, and must use the [`containerd image store`](https://docs.docker.com/storage/containerd/) feature. To enable this in your Github workflow, use `ghaction-setup-docker`'s [daemon-configuration](https://github.com/crazy-max/ghaction-setup-docker#daemon-configuration) to set `"containerd-snapshotter": true`. 

If you are using a buildx instance, or using buildkitd directly and providing `buildkit-version`, there is no need to enable the containerd image store. However, only images in a remote registry can be patched using these methods.

Note: Patching local or private images only available with Copa version v0.6.0 and later. If using Copa v0.5.0 or earlier, you must use provide a buildkit version to run buildkit as a container.
