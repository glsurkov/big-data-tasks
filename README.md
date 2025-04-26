### How to run guideline
 
Run hadoop cluster
```bash
  docker compose up -d
```
Run job
```bash
  make wordcount TASK=task_1
```

### Setup info
Datasets are stored here: ```cd resources```

Outputs are stored here: ```cd tasks/$TASK/output```