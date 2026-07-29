{{- define "edulearn-common.secret" -}}
{{- if not (and .Values.externalSecret .Values.externalSecret.enabled) }}
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
{{- end }}
