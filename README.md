# MLOps Platform

## Quick start

```bash
# Up all
bash run.sh all up
# Down all
bash run.sh all down

# Up a specific service
bash run.sh feast up
# Down a specific service
bash run.sh feast down

# Test elasticsearch
curl -X GET http://localhost:9200 -u elastic:changeme

# Test kibana, open http://localhost:5601 in browser
# Login with user='elastic', password='changeme'
```
