{{- define "edulearn.externalsecret" -}}

{{- if .Values.externalsecret.enabled }}

apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret

metadata:
  name: {{ .Values.externalsecret.targetSecretName }}

spec:

  refreshInterval:
    {{ .Values.externalsecret.refreshInterval }}

  secretStoreRef:
    name:
      {{ .Values.externalsecret.secretStore.name }}

    kind:
      {{ .Values.externalsecret.secretStore.kind }}

  target:
    name:
      {{ .Values.externalsecret.targetSecretName }}

    creationPolicy: Owner

  data:

  {{- range .Values.externalsecret.data }}

    - secretKey:
        {{ .secretKey }}

      remoteRef:
        key:
          {{ .remoteKey }}

        property:
          {{ .property }}

  {{- end }}

{{- end }}

{{- end }}