{{- define "edulearn-common.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "edulearn-common.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{- define "edulearn-common.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "edulearn-common.labels" -}}
helm.sh/chart: {{ include "edulearn-common.chart" . }}
{{ include "edulearn-common.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: {{ .Release.Namespace }}

{{- end }}

{{- define "edulearn-common.selectorLabels" -}}
app.kubernetes.io/name: {{ include "edulearn-common.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}


{{/*
Wait for infrastructure dependencies before starting the app container.
Usage:
{{ include "edulearn.waitForDependencies" . | nindent 6 }}
*/}}
{{- define "edulearn.waitForDependencies" -}}
{{- $deps := .Values.waitFor | default dict -}}
{{- if or $deps.postgres $deps.redis $deps.kafka }}
initContainers:
{{- if $deps.postgres }}
  - name: wait-for-postgres
    image: postgres:17
    imagePullPolicy: IfNotPresent
    command:
      - sh
      - -c
      - |
        until pg_isready -h {{ .Values.global.postgres.host }} -p {{ .Values.global.postgres.port }} -U {{ .Values.global.postgres.user }}; do
          echo "Waiting for PostgreSQL..."
          sleep 2
        done
{{- end }}

{{- if $deps.redis }}
  - name: wait-for-redis
    image: redis:8
    imagePullPolicy: IfNotPresent
    command:
      - sh
      - -c
      - |
        until redis-cli -h {{ .Values.global.redis.host }} -p {{ .Values.global.redis.port }} ping | grep PONG; do
          echo "Waiting for Redis..."
          sleep 2
        done
{{- end }}

{{- if $deps.kafka }}
  - name: wait-for-kafka
    image: bitnami/kafka:4.0.0-debian-12-r5
    imagePullPolicy: IfNotPresent
    command:
      - sh
      - -c
      - |
        until nc -z {{ .Values.global.kafka.host }} {{ .Values.global.kafka.port }}; do
          echo "Waiting for Kafka..."
          sleep 2
        done
{{- end }}
{{- end }}
{{- end }}