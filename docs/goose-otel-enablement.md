# Goose OTel Enablement

## Overview

Goose v1.43.0 ships with built-in OpenTelemetry instrumentation (using the Rust OTel SDK v0.32) covering traces, metrics, and logs. You can enable this functionality on initial setup of Goose, or at a later point in time, in the [Goose configuration YAML](~/.config/goose/config.yaml). 

This document summarizes all the changes made to enable and pipeline that telemetry.

---

## Configuration

### 1. Configure environment variables

Create a copy of [`.env.example`](.env.example):

```bash
cp .env.example .env
```

If you choose to use [Dynatrace](https://dt-url.net/dt-trial) as your observability backend, uncomment and replace the details for the following environment variables:

* `DT_ENDPOINT`: [your Dynatrace endpoint](https://www.dynatrace.com/news/blog/send-opentelemetry-data-to-dynatrace/#your-dynatrace-tenant)
* `DT_API_TOKEN`: [your Dynatrace API token](https://www.dynatrace.com/news/blog/send-opentelemetry-data-to-dynatrace/#create-a-dynatrace-access-token)

### 2. Goose config — enable telemetry

**File:** [`~/.config/goose/config.yaml`](~/.config/goose/config.yaml)

```yaml
# Before
GOOSE_TELEMETRY_ENABLED: false

# After
GOOSE_TELEMETRY_ENABLED: true
```

This is the single Goose-specific flag that activates its OTel SDK instrumentation. The destination is controlled separately via standard `OTEL_*` environment variables.

### 3. Configure OTel Collector

**File:** [`src/otel/otel-collector-config.yaml`](/src/otel/otel-collector-config.yaml)

Configures the OTel Collector to:
- Receive OTLP on **gRPC** (`0.0.0.0:4317`) and **HTTP** (`0.0.0.0:4318`)
- Export to the **debug** (stdout) exporter for development visibility
- Forward to **Jaeger** over OTLP HTTP for trace visualisation
- Includes a **Dynatrace** exporter

### 4. Start OTel components

**File:** [`start-otel.sh`](/src/scripts/start-otel.sh)

Loads the environment variables required by Goose and the OTel Collector and wraps `docker compose up -d`.

[`docker-compose.yaml`](/docker-compose.yml) starts two containers:

| Service | Image | Exposed ports |
|---|---|---|
| `otel-collector` | `otel/opentelemetry-collector-contrib:0.128.0` | `4317` (gRPC), `4318` (HTTP) |
| `jaeger` | `jaegertracing/jaeger:2.7.0` | `16686` (UI) |

Run the script:

```bash
./src/scripts/start-otel.sh .env
```

If you would like to exclude the Dynatrace components, simply comment out linese referencing the DT Collector configuration from [`docker-compose.yaml`](/docker-compose.yml):

Before:

```yaml
otel-collector:
  image: otel/opentelemetry-collector-contrib:0.128.0
  command:
    - "--config=/etc/otel/config.yaml"
    - "--config=/etc/otel/config-dt.yaml"
  volumes:
    - ./src/otel/otel-collector-config.yaml:/etc/otel/config.yaml
    - ./src/otel/otel-collector-config-dt.yaml:/etc/otel/config-dt.yaml
```

After:

```yaml
otel-collector:
  image: otel/opentelemetry-collector-contrib:0.128.0
  command:
  - "--config=/etc/otel/config.yaml"
  # - "--config=/etc/otel/config-dt.yaml"
  volumes:
    - ./src/otel/otel-collector-config.yaml:/etc/otel/config.yaml
    # - ./src/otel/otel-collector-config-dt.yaml:/etc/otel/config-dt.yaml
```

### 5. Start Goose with OTel

Set the standard OTel env vars from `.env`before starting a Goose session:

```bash
export $(grep -v '^#' .env | xargs) && goose session
```

Telemetry flows to the OTel Collector, then to Jaeger (traces only) and simultaneously to Dynatrace (traces, logs, metrics).

**Jaeger UI:** http://localhost:16686
**Dynatrace UI:** https://<your_tenant_id>.live.dynatrace.com

---

## Nukify

To bring down the Docker services, run `docker compose down`.

---

## Verification

Goose is written in Rust and emits telemetry using the [Rust OpenTelemetry instrumentation libraries](https://opentelemetry.io/docs/languages/rust/).

You will be able to see traces, logs, and metrics for Goose, by filtering on attribute `service.name` having a value of `goose`.

Goose prompts and results are captured in OTel [spans](https://opentelemetry.io/docs/concepts/signals/traces/#spans) (children of a [trace](https://opentelemetry.io/docs/concepts/signals/traces/)): 
* Prompts are stored in the `trace_input` and `user_message` fields of the span
* Prompt results are stored in the `trace_output`
* The prompt input span is disconnected from the prompt output trace (i.e. they're not part of the same trace)
* All prompts in the same session have the same `sesison.id`

![Jaeger Goose span](/images/jaeger-goose-trace.png)

![Dynatrace Goose spans showing input and output together](/images/dt-goose-trace.png)

> **NOTE:** Jaeger spans show up as `service.namespace`. That attribute label is also visible in Dynatrace spans and logs, but not metrics (they only use `service.name`)