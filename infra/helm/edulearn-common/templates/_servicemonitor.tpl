{{- define "edulearn-common.servicemonitor" -}}
{{- if and .Values.serviceMonitor .Values.serviceMonitor.enabled }}
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: {{ include "edulearn-common.fullname" . }}
  namespace: {{ .Values.serviceMonitor.namespace | default "observability" }}
  labels:
    {{- include "edulearn-common.labels" . | nindent 4 }}
    release: kube-prometheus-stack
spec:
  namespaceSelector:
    matchNames:
      - {{ .Release.Namespace }}
  selector:
    matchLabels:
      {{- include "edulearn-common.labels" . | nindent 6 }}
  endpoints:
    - port: {{ .Values.serviceMonitor.port | default "http" | quote }}
      path: {{ .Values.serviceMonitor.path | default "/metrics" | quote }}
      interval: {{ .Values.serviceMonitor.interval | default "30s" | quote }}
      scrapeTimeout: {{ .Values.serviceMonitor.scrapeTimeout | default "10s" | quote }}
{{- end }}
{{- end }}