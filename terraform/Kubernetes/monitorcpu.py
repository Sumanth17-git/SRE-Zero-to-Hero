import os
import subprocess
import time

def get_node_cpu_usage():
    """
    Fetch CPU usage for all nodes using `kubectl top nodes`.
    Calculate percentage usage for each node.
    """
    print("Fetching node CPU usage...")
    try:
        result = subprocess.run(["kubectl", "top", "nodes"], capture_output=True, text=True, check=True)
        lines = result.stdout.splitlines()[1:]  # Skip the header
        node_usages = []

        for line in lines:
            parts = line.split()
            node_name = parts[0]
            used_cpu = int(parts[1].replace("m", "")) / 1000  # Convert milli-cores to cores
            allocatable_cpu = 1  # Assume 1 core for simplicity; adjust this value to your actual setup
            usage_percentage = (used_cpu / allocatable_cpu) * 100
            node_usages.append((node_name, usage_percentage))

        return node_usages

    except subprocess.CalledProcessError as e:
        print(f"Error fetching CPU usage: {e.stderr}")
        return []

def update_machine_type(machine_type):
    """
    Update the machine type using Terraform.
    """
    print(f"Updating machine type to {machine_type}...")
    os.environ['TF_VAR_machine_type'] = machine_type
    try:
        result = subprocess.run(["terraform", "apply", "-auto-approve"], check=True)
        print(f"Terraform executed successfully: {result}")
    except subprocess.CalledProcessError as e:
        print(f"Error during Terraform execution: {e}")

def main():
    high_cpu_threshold = 80  # 80% usage
    low_cpu_threshold = 20   # 20% usage
    current_machine_type = "e2-standard-4"

    print("Starting Kubernetes node CPU monitoring...")
    while True:
        try:
            node_usages = get_node_cpu_usage()

            if not node_usages:
                print("No node data available.")
                time.sleep(30)
                continue

            for node_name, usage in node_usages:
                print(f"Node: {node_name}, CPU Usage: {usage:.2f}%")

                if usage > high_cpu_threshold and current_machine_type == "e2-standard-4":
                    print(f"High CPU usage detected on {node_name}. Scaling up...")
                    update_machine_type("e2-highmem-4")
                    current_machine_type = "e2-highmem-4"

                elif usage < low_cpu_threshold and current_machine_type == "e2-highmem-4":
                    print(f"Low CPU usage detected on {node_name}. Scaling down...")
                    update_machine_type("e2-standard-4")
                    current_machine_type = "e2-standard-4"

            time.sleep(30)  # Check every 30 seconds

        except KeyboardInterrupt:
            print("Monitoring stopped.")
            break

if __name__ == "__main__":
    main()