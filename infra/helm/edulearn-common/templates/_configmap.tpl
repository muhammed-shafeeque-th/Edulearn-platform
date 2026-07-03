{{- define "edulearn-common.configmap" -}}
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "edulearn-common.fullname" . }}-config
  labels:
    {{- include "edulearn-common.labels" . | nindent 4 }}
data:
{{- if .Values.configData }}
{{- range $key, $value := .Values.configData }}
  {{ $key }}: {{ $value | quote }}
{{- end }}
{{- end }}
{{- end }}
