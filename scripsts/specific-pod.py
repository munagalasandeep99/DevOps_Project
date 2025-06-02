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

def get_pod_usage(pod_name, namespace=None):
    ns_filter = f'namespace="{namespace}",' if namespace else ''
    
    # Query current CPU usage (instantaneous rate)
    cpu_query = f'rate(container_cpu_usage_seconds_total{{pod="{pod_name}",{ns_filter}image!=""}}[5m])'
    cpu_results = query_prometheus(cpu_query)
    
    # Query current memory usage
    mem_query = f'container_memory_usage_bytes{{pod="{pod_name}",{ns_filter}image!=""}}'
    mem_results = query_prometheus(mem_query)
    
    cpu_usage = 0
    mem_usage = 0
    

    for item in cpu_results:
        cpu_usage += float(item['value'][1])
    

    for item in mem_results:
        mem_usage += float(item['value'][1])
    
    usage = {
        "pod": pod_name,
        "namespace": namespace if namespace else "default",
        "cpu_usage_cores": cpu_usage,
        "memory_usage_bytes": mem_usage
    }
    return usage

# Example usage:
pod_name = "grafana-7c96b5b9cc-rcpkb"           # Replace with your pod name
namespace = "default"          # Replace with your namespace or None

usage = get_pod_usage(pod_name, namespace)
print(json.dumps(usage, indent=2))
