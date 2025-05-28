
# Ericsson Task



### Task 1: Build a Kubernetes Cluster.
- Open www.skyscanner.net
- Give origin as "Stockholm" and destination as "Everywhere" (Överallt in Swedish)
- Choose travel dates 22 Dec 2023 and return date 06 Jan 2024 and 1 adult as passenger.
- Search for flights
- Click on the first entry and see the lowest price shown there is same as the lowest price shown when clicked on the link.
- For ex : if it shows 500 SEK for Gothenburg as cheapest as first link, when clicked on the link it should show same 500 SEK as cheapest. If it shows different price, then the test case should be failed. Otherwise it should show as passed.

You can choose any open source testing tool of your choice. For Ex : selenium, playwright, webdriverIO etc

<p>Approach:</p>

### Task 2: Deploy a Sample Application
- The sample application is a todo application developed using React for front end, Node.js for Backend ad mongodb as database
- Now from the work station clone the repository using the command
```Shell
https://github.com/munagalasandeep99/ericcson-task.git
cd ericcson/Kubernetes-Manifests-file
kubectl create -f . 
```
```Shell
cd Frontend
kubectl create -f . 
```
```Shell
cd ../Database
kubectl create -f . 
```
```Shell
cd ../Backend
kubectl create -f . 
```

## deliverables
<h>Application code and kubernetes manifests</h>: the applcation code is present in Application_code file and Kubernetes-Manifests-file repectively above

<h>video</h> href="https://drive.google.com/file/d/130-2luUJOdhsTmaNA7UzeeI31t-fUfyh/view?usp=sharing"

### Task 3:Monitoring with Prometheus &amp; Grafana.
- Step 1: Add Helm Repositories

```bash
# Add Prometheus Community Helm repo
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

# Add Grafana Helm repo
helm repo add grafana https://grafana.github.io/helm-charts

# Update Helm repos
helm repo update
```
- Step 2: Install Prometheus and Grafana
```bash
# Install Prometheus
helm install prometheus prometheus-community/prometheus

# Install Grafana
helm install grafana grafana/grafana
```
- Step 3: Verify Services
```bash
kubectl get svc
```
look for prometheus-server and graphana
- Step 4: Expose Prometheus and Grafana (Change Service Type)
```bash
kubectl edit svc prometheus-server
```
modify the yaml
```yaml
spec:
  type: LoadBalancer
```
edit Graphana service
```bash
kubectl edit svc grafana
```
modify
```yaml
spec:
  type: LoadBalancer
```
- step 5:Get External Access URLs
```bash
kubectl get svc
```
note down the loadbalncer dns for Prometheus and graphana

now you can access prometheus and graphana ui using loadbancer dns you get

# Task 4
- file: monitor.sh and prometheus-query.py are present in scripts folder above.
- Monitor.sh - checks the memory and cpu usage of the pod and alerts us by printing messages ,before running the script change the pod name and name space , if wanted change the thresholds.
  ```shell
  chmod +x monitor.sh
  ./monitor.sh
  ```
  - file prometheus-query.py - displays all the pods their cpu usage and memory usage and stores in a json file .
  - file specific-pod.py - displays the current cpu and memory usage and stores in a json file, before running you need to mention the pod name and namespace name
 ```shell
  pip install requests
  pip prometheus-query.py
  pip specific-pod.py
  ```
<b>deliverables</b>
- it are placed in scriptin results folder
- monitor.sh results
```bash
Pod: mongodb-59797b688c-kz5xz
CPU Usage: 0.004 cores
Memory Usage: 0.147461 GB
⚠️ ALERT: CPU usage (0.004 cores) exceeds threshold (0.0005 cores)
⚠️ ALERT: Memory usage (0.147461 GB) exceeds threshold (0.005 GB)
```
- prometheus-query.py results
```bash
    "namespace": "argocd",
    "pod": "argocd-dex-server-868bf8bc97-5xkzz",
    "cpu_usage_cores": 0.00011863982447377208,
    "memory_usage_bytes": 17244160.0
  },
  {
    "namespace": "kube-system",
    "pod": "aws-load-balancer-controller-7dcc74f48b-q268p",
    "cpu_usage_cores": 0.0012479037558203326,
    "memory_usage_bytes": 36925440.0
  },
  {
    "namespace": "kube-system",
    "pod": "coredns-54d6f577c6-5bmth",
    "cpu_usage_cores": 0.0010439434835204096,
    "memory_usage_bytes": 26140672.0
  },
  {
    "namespace": "kube-system",
    "pod": "kube-proxy-44wpn",
    "cpu_usage_cores": 0.00024203313184795584,
    "memory_usage_bytes": 26836992.0
  },
  {
    "namespace": "kube-system",
    "pod": "metrics-server-75bf97fcc9-vkmtf",
    "cpu_usage_cores": 0.0022688706563227506,
    "memory_usage_bytes": 21487616.0
  },
  {
    "namespace": "kube-system",
    "pod": "aws-node-rrxjq",
    "cpu_usage_cores": 0.002551196003781295,
    "memory_usage_bytes": 80793600.0
  },
  {
    "namespace": "kube-system",
    "pod": "ebs-csi-controller-6b7d79c8cf-k599r",
    "cpu_usage_cores": 0.0002469042338457355,
    "memory_usage_bytes": 10289152.0
  },
  {
    "namespace": "kube-system",
    "pod": "ebs-csi-node-6vs2g",
    "cpu_usage_cores": 0.00018655863190880268,
    "memory_usage_bytes": 5328896.0
  },
  {
    "namespace": "three-tier",
    "pod": "frontend-5c75bc9c59-7pg96",
    "cpu_usage_cores": 0.00019587020448713708,
    "memory_usage_bytes": 258326528.0
  },
  {
    "namespace": "default",
    "pod": "prometheus-prometheus-node-exporter-6lfbh",
    "cpu_usage_cores": 0.000425646221971775,
    "memory_usage_bytes": 10043392.0
  },
  {
    "namespace": "argocd",
    "pod": "argocd-server-7bc9d78cf4-92jkb",
    "cpu_usage_cores": 0.0006789189149755883,
    "memory_usage_bytes": 74289152.0
  },
  {
    "namespace": "kube-system",
    "pod": "aws-load-balancer-controller-7dcc74f48b-w2g5f",
    "cpu_usage_cores": 0.001982111098708069,
    "memory_usage_bytes": 50307072.0
  },
  {
    "namespace": "default",
    "pod": "prometheus-prometheus-pushgateway-9847c5479-djxcl",
    "cpu_usage_cores": 0.00010108051842580082,
    "memory_usage_bytes": 9052160.0
  },
  {
    "namespace": "argocd",
    "pod": "argocd-notifications-controller-5fff689764-s79s2",
    "cpu_usage_cores": 0.00021564080389414037,
    "memory_usage_bytes": 17547264.0
  },
  {
    "namespace": "three-tier",
    "pod": "mongodb-59797b688c-kz5xz",
    "cpu_usage_cores": 0.0035796032718287863,
    "memory_usage_bytes": 172761088.0
  },
  {
    "namespace": "argocd",
    "pod": "argocd-applicationset-controller-749957bcc9-jkn66",
    "cpu_usage_cores": 0.0005078682096669877,
    "memory_usage_bytes": 19415040.0
  },
  {
    "namespace": "three-tier",
    "pod": "api-65fd846f99-5vjgz",
    "cpu_usage_cores": 0.0005916648923300266,
    "memory_usage_bytes": 35373056.0
  },
  {
    "namespace": "kube-system",
    "pod": "ebs-csi-node-8qsnl",
    "cpu_usage_cores": 0.00021192605438230094,
    "memory_usage_bytes": 5079040.0
  },
  {
    "namespace": "kube-system",
    "pod": "coredns-54d6f577c6-f9d5b",
    "cpu_usage_cores": 0.0010618448224665486,
    "memory_usage_bytes": 21196800.0
  },
  {
    "namespace": "kube-system",
    "pod": "aws-node-9rxc7",
    "cpu_usage_cores": 0.0027198859814959696,
    "memory_usage_bytes": 68820992.0
  },
  {
    "namespace": "kube-system",
    "pod": "kube-proxy-hvxbn",
    "cpu_usage_cores": 0.0002079354558953648,
    "memory_usage_bytes": 19542016.0
  },
  {
    "namespace": "kube-system",
    "pod": "ebs-csi-controller-6b7d79c8cf-wrxvm",
    "cpu_usage_cores": 0.00024185240553704308,
    "memory_usage_bytes": 9453568.0
  },
  {
    "namespace": "default",
    "pod": "prometheus-server-564cfc9b9f-jpvwz",
    "cpu_usage_cores": 7.099864458842471e-05,
    "memory_usage_bytes": 8798208.0
  },
  {
    "namespace": "default",
    "pod": "grafana-7c96b5b9cc-rcpkb",
    "cpu_usage_cores": 0.003038098635281149,
    "memory_usage_bytes": 127254528.0
  }
]
```
-specific-pod.py results
```bash
{
  "pod": "grafana-7c96b5b9cc-rcpkb",
  "namespace": "default",
  "cpu_usage_cores": 0.0026442196210575974,
  "memory_usage_bytes": 127459328.0
}
```
