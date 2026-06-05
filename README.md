# Sausage Store

## Реализация

Реализовано задание без усложненного варианта.

Проверить деплой: https://front-fleshbound.2sem.students-projects.ru/

### 1. Корректность Dockerfile

Реализованы следующие файлы Docker:
- [backend](backend/Dockerfile)
- [backend-report](backend-report/Dockerfile)
- [frontend](frontend/Dockerfile)

### 2. Настроенные миграции и конфигурация базы данных

[Миграции](backend/src/main/resources/db/migration)

[Конфигурация PostgreSQL](./sausage-store-chart/charts/infra/templates/postgresql.yaml)

### 3. Корректность Helm-чартов и деплоя

Структура Helm-чартов:
```
sausage-store-chart
    ├── Chart.yaml
    ├── charts
    │   ├── backend
    │   │   ├── Chart.yaml
    │   │   └── templates
    │   │       ├── configmap.yaml
    │   │       ├── deployment.yaml
    │   │       └── service.yaml
    │   ├── backend-report
    │   │   ├── Chart.yaml
    │   │   └── templates
    │   │       ├── configmap.yaml
    │   │       ├── deployment.yaml
    │   │       ├── hpa.yaml
    │   │       ├── secret.yaml
    │   │       └── service.yaml
    │   ├── frontend
    │   │   └── templates
    │   │       ├── configmap.yaml
    │   │       ├── deployment.yaml
    │   │       └── ingress.yaml
    │   └── infra
    │       ├── Chart.yaml
    │       └── templates
    │           ├── mongodb-job.yaml
    │           ├── mongodb.yaml
    │           └── postgresql.yaml
    └── values.yaml  
```

### 4. Настройка автоматического масштабирования и мониторинга

[HPA](sausage-store-chart/charts/backend-report/templates/hpa.yaml):
```
> kubectl get hpa -n $NAMESPACE
NAME                               REFERENCE                                 TARGETS       MINPODS   MAXPODS   REPLICAS   AGE
sausage-store-backend-report-hpa   Deployment/sausage-store-backend-report   cpu: 2%/70%   1         3         1          103m
```

[VPA](sausage-store-chart/charts/backend/templates/deployment.yaml#90):
```
> kubectl get vpa -n $NAMESPACE
NAME                        MODE   CPU   MEM     PROVIDED   AGE
sausage-store-backend-vpa   Off    35m   256Mi   True       105m
```

LivenessProbe для backend:
- [values.yaml](sausage-store-chart/values.yaml#68):
    ```
    livenessProbe:
        httpGet:
        path: /actuator/health
        port: 8080
        initialDelaySeconds: 90
        periodSeconds: 10
    ```
- [deployment.yaml](sausage-store-chart/charts/backend/templates/deployment.yaml#72):
    ```
          livenessProbe:
    {{ toYaml .Values.livenessProbe | indent 12 }}
    ```

### 5. Стратегии деплоя

- backend - [RollingUpdate](sausage-store-chart/values.yaml#53)
- backend-report - [Recreate](sausage-store-chart/values.yaml#93)
- frontend - [Recreate](sausage-store-chart/values.yaml#18)

Поднятые поды:
```
> kubectl get pods -n $NAMESPACE
NAME                                            READY   STATUS      RESTARTS      AGE
mongodb-0                                       1/1     Running     0             100m
mongodb-init-reports-rb8dp                      0/1     Completed   0             7m11s
postgresql-0                                    1/1     Running     0             100m
sausage-store-backend-6bcff8fb46-tx4zj          1/1     Running     0             15m
sausage-store-backend-report-744767b7f9-dbnl9   1/1     Running     2 (99m ago)   100m
sausage-store-frontend-5b9bd4dcc7-9rlc4         1/1     Running     0             15m
```

## Image

![image](https://user-images.githubusercontent.com/9394918/121517767-69db8a80-c9f8-11eb-835a-e98ca07fd995.png)


## Technologies used

* Frontend – TypeScript, Angular.
* Backend  – Java 16, Spring Boot, Spring Data.
* Database – H2.

## Installation guide
### Backend

Install Java 16 and maven and run:

```bash
cd backend
mvn package
cd target
java -jar sausage-store-0.0.1-SNAPSHOT.jar
```

### Frontend

Install NodeJS and npm on your computer and run:

```bash
cd frontend
npm install
npm run build
npm install -g http-server
sudo http-server ./dist/frontend/ -p 80 --proxy http://localhost:8080
```

Then open your browser and go to [http://localhost](http://localhost)
