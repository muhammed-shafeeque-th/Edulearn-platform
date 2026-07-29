{{/*  PodDisruptionBudget  for HA (per your CHANGED comments), but no PDB exists anywhere in
     rendered.yaml for the app charts — a node drain can currently take both
     replicas down at once. Wire this into each component's templates/
     pdb.yaml and enable it via values for auth/payment at minimum. */}}
     
{{- define "edulearn-common.pdb" -}}
{{- if and .Values.podDisruptionBudget .Values.podDisruptionBudget.enabled }}
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: {{ include "edulearn-common.fullname" . }}
  labels:
    {{- include "edulearn-common.labels" . | nindent 4 }}
spec:
  {{- if .Values.podDisruptionBudget.minAvailable }}
  minAvailable: {{ .Values.podDisruptionBudget.minAvailable }}
  {{- else }}
  maxUnavailable: {{ .Values.podDisruptionBudget.maxUnavailable | default 1 }}
  {{- end }}
  selector:
    matchLabels:
      {{- include "edulearn-common.selectorLabels" . | nindent 6 }}
{{- end }}
{{- end }}