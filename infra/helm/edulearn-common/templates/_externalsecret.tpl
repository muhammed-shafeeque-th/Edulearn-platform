{{- define "edulearn-common.externalsecret" -}}
{{- if .Values.externalSecret.enabled }}
---
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: {{ include "edulearn-common.fullname" . }}-secrets
  labels:
    {{- include "edulearn-common.labels" . | nindent 4 }}
  {{- if .Values.externalSecret.annotations }}
  annotations:
    {{- toYaml .Values.externalSecret.annotations | nindent 4 }}
  {{- end }}
spec:
  refreshInterval: {{ .Values.externalSecret.refreshInterval | default "5m" }}

  secretStoreRef:
    name: {{ .Values.externalSecret.secretStoreRef.name | default "aws-secrets-manager" }}
    kind: {{ .Values.externalSecret.secretStoreRef.kind | default "ClusterSecretStore" }}

  target:
    name: {{ .Values.externalSecret.targetSecretName | default (include "edulearn-common.fullname" .) }}-secrets
    creationPolicy: {{ .Values.externalSecret.targetCreationPolicy | default "Owner" }}

  {{- if .Values.externalSecret.dataFrom }}
  dataFrom:
    {{- toYaml .Values.externalSecret.dataFrom | nindent 4 }}
  {{- else if .Values.externalSecret.data }}
  data:
    {{- range .Values.externalSecret.data }}
    - secretKey: {{ .secretKey }}
      remoteRef:
        key: {{ .remoteKey }}
        {{- if .property }}
        property: {{ .property }}
        {{- end }}
    {{- end }}
  {{- end }}

{{- end }}
{{- end }}