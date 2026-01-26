up: A basic Prometheus metric that shows the health of a scraped target (1 if healthy, 0 if down).
http_requests_total: A counter metric often used in web applications to track the total number of HTTP requests, typically labeled by status code (status), path (path), and method (method).
api_request_duration_seconds: A histogram or summary metric that tracks the duration of API requests, allowing you to monitor latency and performance over time.
node_cpu_seconds_total: A Node Exporter metric for monitoring CPU usage, broken down by different modes (e.g., idle, system, user).
process_resident_memory_bytes: A gauge metric showing the current memory usage of a running process