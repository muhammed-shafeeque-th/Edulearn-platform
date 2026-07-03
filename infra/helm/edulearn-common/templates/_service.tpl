{{- define "edulearn-common.service" -}}
apiVersion: v1
kind: Service
metadata:
  name: {{ include "edulearn-common.fullname" . }}
  labels:
    {{- include "edulearn-common.labels" . | nindent 4 }}
spec:
  type: {{ .Values.service.type }}
  ports:
    {{- with .Values.service.ports }}
    {{- toYaml . | nindent 4 }}
    {{- else }}
    - port: {{ .Values.service.port }}
      targetPort: http
      protocol: TCP
      name: http
    {{- end }}
  selector:
    {{- include "edulearn-common.selectorLabels" . | nindent 4 }}
{{- end }}