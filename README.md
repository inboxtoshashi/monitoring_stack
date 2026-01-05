# monitoring_stack

This repo will help to apply the monitoring_stack on the apps.

## Overview

The monitoring stack includes:
- **Prometheus**: Metrics collection and storage (Port: 9091)
- **Grafana**: Metrics visualization and dashboards (Port: 3000)
- **Node Exporter**: System metrics collector (Port: 9100)
- **Blackbox Exporter**: Endpoint health monitoring (Port: 9115)
- **cAdvisor**: Container metrics and resource usage (Port: 8080)

## Integration with URL Shortener App

The monitoring stack is automatically deployed alongside the URL Shortener application and connects to:
- **URL Shortener Backend**: Scrapes Prometheus metrics from port 9100
- **URL Shortener Frontend**: Health checks via Blackbox exporter
- **Docker Containers**: Monitors all containers via cAdvisor
- **EC2 Instance**: System metrics via Node Exporter

## Deployment

### Automatic Deployment (via Jenkins)
1. Deploy infrastructure: Run `deploy-infra` Jenkins job
2. Deploy application: Run `deploy-app` Jenkins job (includes monitoring)
3. Or deploy monitoring separately: Run `deploy-monitoring` Jenkins job

### Manual Deployment
```bash
# From the EC2 instance after app is deployed
cd /home/ubuntu
./deploy_monitoring.sh
```

## Accessing Monitoring Services

After deployment, access the following services using your EC2 public IP:

- **Grafana**: `http://<EC2_IP>:3000`
  - Username: `admin`
  - Password: `admin`
  - Pre-configured dashboards for URL Shortener app

- **Prometheus**: `http://<EC2_IP>:9091`
  - View metrics and targets
  - Query app and system metrics

- **Node Exporter**: `http://<EC2_IP>:9100`
- **Blackbox Exporter**: `http://<EC2_IP>:9115`
- **cAdvisor**: `http://<EC2_IP>:8080`

## Grafana Dashboards

Pre-configured dashboards include:
- **URL Shortener Dashboard**: Application-specific metrics
- **App Monitoring Dashboard**: Overall application health
- **Endpoint Monitoring**: Per-endpoint performance metrics

## Network Architecture

The monitoring stack uses the `monitoring` Docker network (created by the URL Shortener app) to communicate with application containers. All services run in the same network for seamless metric collection.

## Troubleshooting

Check container status:
```bash
cd monitoring_stack
docker compose -f monitoring.yml ps
```

View logs:
```bash
docker compose -f monitoring.yml logs -f [service_name]
```

Restart monitoring stack:
```bash
docker compose -f monitoring.yml restart
```
