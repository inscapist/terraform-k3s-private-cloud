# Volume

## Make `ebs-sc` default storageclass

```sh
kubectl patch storageclass ebs-sc -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
```

## Volume Expansion

This kubernetes distribution supports Volume Expansion.

It generally involves 3 steps:

1. kubectl edit pvc/PVC_NAME
2. update `spec.resources.requests.storage` to desired size
3. restart the dependent pods (eg. kubectl delete $POD)

#### Healthy log

It should end with event `FileSystemResizeSuccessful`

```
  Normal   Resizing                    4m7s                   external-resizer ebs.csi.aws.com                                                          External resizer is resizing volume pvc-3ac91c9b-66e9-4879-ac2c-c4dcb207e364
  Warning  ExternalExpanding           4m7s                   volume_expand                                                                             Ignoring the PVC: didn't find a plugin capable of expanding the volume; waiting for an external controller to process this PVC.
  Normal   Resizing                    4m6s                   external-resizer ebs.csi.aws.com                                                          External resizer is resizing volume pvc-3ac91c9b-66e9-4879-ac2c-c4dcb207e364
  Warning  VolumeResizeFailed          4m1s                   external-resizer ebs.csi.aws.com                                                          can't patch status of  PVC default/data-volume-fetias-mongodb-0 with Operation cannot be fulfilled on persistentvolumeclaims "data-volume-fetias-mongodb-0": the object has been modified; please apply your changes to the latest version and try again
  Normal   FileSystemResizeRequired    4m                     external-resizer ebs.csi.aws.com                                                          Require file system resize of volume on node
  Normal   FileSystemResizeSuccessful  3m27s                  kubelet                                                                                   MountVolume.NodeExpandVolume succeeded for volume "pvc-3ac91c9b-66e9-4879-ac2c-c4dcb207e364"

```
