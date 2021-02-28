# Taint and Toleration

## Evict workload from master node

You may find works are scheduled in master node. This is the default behavior of k3s. 
If this is not desirable, you can add taints to the master node:

```
kubectl taint nodes \
  $MASTER_NODE \
  node-role.kubernetes.io/master=true:NoExecute
```

To remove the taint:

```
kubectl taint nodes \
  $MASTER_NODE \
  node-role.kubernetes.io/master=true:NoExecute-
```

`NoExecute` is used as the key here, which will *evict* your existing workload. If this is not what you want, you can change to `NoSchedule`
