import requests
import json

PROMETHEUS_URL = "http://ad94493b365f94df59cbfe785807a2e5-1222207996.us-east-1.elb.amazonaws.com/api/v1/query"

def query_prometheus(query):
    response = requests.get(PROMETHEUS_URL, params={'query': query})
    if response.status_code == 200:
        return response.json().get('data', {}).get('result', [])
    else:
        print(f"Error querying Prometheus: {response.status_code}")
        return []

# Query CPU usage rate over 5 minutes
cpu_query = 'rate(container_cpu_usage_seconds_total{image!=""}[5m])'
cpu_results = query_prometheus(cpu_query)

# Query memory usage in bytes
mem_query = 'container_memory_usage_bytes{image!=""}'
mem_results = query_prometheus(mem_query)

# Map pod/container to CPU and memory usage
pod_stats = {}

for item in cpu_results:
    metric = item['metric']
    pod = metric.get('pod')
    namespace = metric.get('namespace')
    cpu_usage = float(item['value'][1])  # CPU usage in cores
    key = (namespace, pod)
    pod_stats.setdefault(key, {})
    pod_stats[key]['cpu_usage_cores'] = cpu_usage

for item in mem_results:
    metric = item['metric']
    pod = metric.get('pod')
    namespace = metric.get('namespace')
    mem_usage_bytes = float(item['value'][1])
    key = (namespace, pod)
    pod_stats.setdefault(key, {})
    pod_stats[key]['memory_usage_bytes'] = mem_usage_bytes

# Convert to JSON-serializable list of dicts
output = []
for (namespace, pod), usage in pod_stats.items():
    output.append({
        'namespace': namespace,
        'pod': pod,
        'cpu_usage_cores': usage.get('cpu_usage_cores', 0),
        'memory_usage_bytes': usage.get('memory_usage_bytes', 0)
    })

# Write JSON data to a file
with open('pod_usage.json', 'w') as f:
    json.dump(output, f, indent=2)

print("Pod CPU and memory usage data saved to pod_usage.json")
