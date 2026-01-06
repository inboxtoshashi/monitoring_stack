#!/bin/bash
# Configure monitoring stack from config.yml

set -e

CONFIG_FILE="config.yml"

# Read config.yml values (simple parsing)
BACKEND_CONTAINER=$(grep 'backend:' $CONFIG_FILE | awk '{print $2}')
FRONTEND_CONTAINER=$(grep 'frontend:' $CONFIG_FILE | awk '{print $2}')
DB_CONTAINER=$(grep 'database:' $CONFIG_FILE | awk '{print $2}')

echo "Configuring monitoring with:"
echo "  Backend: $BACKEND_CONTAINER"
echo "  Frontend: $FRONTEND_CONTAINER"
echo "  Database: $DB_CONTAINER"

# Process dashboard templates
cd grafana/provisioning/dashboards
for file in *.json; do
    if [ -f "$file" ]; then
        sed -e "s/{{BACKEND_CONTAINER}}/$BACKEND_CONTAINER/g" \
            -e "s/{{FRONTEND_CONTAINER}}/$FRONTEND_CONTAINER/g" \
            -e "s/{{DB_CONTAINER}}/$DB_CONTAINER/g" \
            -i.bak "$file"
        rm -f "$file.bak"
        echo "✓ Configured $file"
    fi
done

# Process prometheus.yml
cd ../../../prometheus
if [ -f "prometheus.yml" ]; then
    sed -e "s/{{BACKEND_CONTAINER}}/$BACKEND_CONTAINER/g" \
        -e "s/{{FRONTEND_CONTAINER}}/$FRONTEND_CONTAINER/g" \
        -e "s/{{DB_CONTAINER}}/$DB_CONTAINER/g" \
        -i.bak "prometheus.yml"
    rm -f prometheus.yml.bak
    echo "✓ Configured prometheus.yml"
fi

cd ../..
echo "✅ Configuration complete! Ready to deploy."
