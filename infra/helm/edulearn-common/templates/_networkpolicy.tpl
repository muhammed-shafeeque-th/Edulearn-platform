{{- define "edulearn-common.networkpolicy" -}}
{{- if and .Values.networkPolicy .Values.networkPolicy.enabled }}
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: {{ include "edulearn-common.fullname" . }}
  labels:
    {{- include "edulearn-common.labels" . | nindent 4 }}
spec:
  podSelector:
    matchLabels:
      {{- include "edulearn-common.selectorLabels" . | nindent 6 }}
  policyTypes:
    - Ingress
    - Egress
  ingress:
    - from:
        - podSelector:
            matchLabels:
              app.kubernetes.io/instance: {{ .Release.Name }}
      {{- if and .Values.networkPolicy .Values.networkPolicy.extraIngress }}
      {{- toYaml .Values.networkPolicy.extraIngress | nindent 4 }}
      {{- end }}
  egress:
    {{- if and .Values.networkPolicy .Values.networkPolicy.egress }}
    {{- toYaml .Values.networkPolicy.egress | nindent 4 }}
    {{- else }}
    - {}
    {{- end }}
{{- end }}
{{- end }}