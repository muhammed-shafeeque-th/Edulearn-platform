{{- define "edulearn-common.hpa" -}}
{{- if .Values.autoscaling.enabled }}
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: {{ include "edulearn-common.fullname" . }}
  labels:
    {{- include "edulearn-common.labels" . | nindent 4 }}
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: {{ include "edulearn-common.fullname" . }}

  minReplicas: {{ .Values.autoscaling.minReplicas }}
  maxReplicas: {{ .Values.autoscaling.maxReplicas }}

  metrics:
    {{- if .Values.autoscaling.targetCPUUtilizationPercentage }}
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: {{ .Values.autoscaling.targetCPUUtilizationPercentage }}
    {{- end }}

    {{- if .Values.autoscaling.targetMemoryUtilizationPercentage }}
    - type: Resource
      resource:
        name: memory
        target:
          type: Utilization
          averageUtilization: {{ .Values.autoscaling.targetMemoryUtilizationPercentage }}
    {{- end }}

  behavior:
    scaleUp:
      stabilizationWindowSeconds: {{ .Values.autoscaling.behavior.scaleUp.stabilizationWindowSeconds | default 0 }}
      policies:
        - type: Percent
          value: {{ .Values.autoscaling.behavior.scaleUp.percent | default 100 }}
          periodSeconds: {{ .Values.autoscaling.behavior.scaleUp.periodSeconds | default 15 }}

    scaleDown:
      stabilizationWindowSeconds: {{ .Values.autoscaling.behavior.scaleDown.stabilizationWindowSeconds | default 300 }}
      policies:
        - type: Percent
          value: {{ .Values.autoscaling.behavior.scaleDown.percent | default 100 }}
          periodSeconds: {{ .Values.autoscaling.behavior.scaleDown.periodSeconds | default 15 }}

{{- end }}
{{- end }}
