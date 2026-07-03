{{- define "edulearn-common.secret" -}}
apiVersion: v1
kind: Secret
metadata:
  name: {{ include "edulearn-common.fullname" . }}-secret
  labels:
    {{- include "edulearn-common.labels" . | nindent 4 }}
type: Opaque
data:
{{- if .Values.secretData }}
  {{- range $key, $value := .Values.secretData }}
  {{ $key }}: {{ $value | b64enc | quote }}
  {{- end }}
{{- end }}
{{- end }}