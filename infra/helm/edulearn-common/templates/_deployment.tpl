{{- define "edulearn-common.deployment" -}}
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "edulearn-common.fullname" . }}
  labels:
    {{- include "edulearn-common.labels" . | nindent 4 }}
spec:
  {{- if not .Values.autoscaling.enabled }}
  replicas: {{ .Values.replicaCount }}
  {{- end }}
  selector:
    matchLabels:
      {{- include "edulearn-common.selectorLabels" . | nindent 6 }}
  template:
    metadata:
      labels:
        {{- include "edulearn-common.selectorLabels" . | nindent 8 }}
      {{- with .Values.podAnnotations }}
      annotations:
        {{- toYaml . | nindent 8 }}
      {{- end }}
    spec:
      {{- with .Values.imagePullSecrets }}
      imagePullSecrets:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      serviceAccountName: {{ include "edulearn-common.serviceAccountName" . }}
      # FIX: no token needed for app pods that don't talk to the k8s API.
      automountServiceAccountToken: {{ .Values.serviceAccount.automount | default false }}
      securityContext:
        {{- toYaml .Values.podSecurityContext | nindent 8 }}
        
      # This causes replicas to be spread across zones.
    {{- if and .Values.topologySpreadConstraints (.Values.topologySpreadConstraints.enabled) }}
      topologySpreadConstraints:
        - maxSkew: {{ .Values.topologySpreadConstraints.maxSkew | default 1 }}
          topologyKey: topology.kubernetes.io/zone
          whenUnsatisfiable: {{ .Values.topologySpreadConstraints.whenUnsatisfiable | default "ScheduleAnyway" }}
          labelSelector:
            matchLabels:
              {{- include "edulearn-common.selectorLabels" . | nindent 14 }}
      {{- end }} 
      containers:
        - name: {{ .Chart.Name }}
          securityContext:
            {{- toYaml .Values.securityContext | nindent 12 }}
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag | default .Chart.AppVersion }}"
          imagePullPolicy: {{ .Values.image.pullPolicy }}
          ports:
            {{- if .Values.service.ports }}
            {{- range .Values.service.ports }}
            - name: {{ .name }}
              containerPort: {{ .targetPort | default .port }}
              protocol: {{ .protocol | default "TCP" }}
            {{- end }}
            {{- else }}
            - name: http
              containerPort: {{ .Values.service.port }}
              protocol: TCP
            {{- end }}
          livenessProbe:
            {{- toYaml .Values.livenessProbe | nindent 12 }}
          readinessProbe:
            {{- toYaml .Values.readinessProbe | nindent 12 }}
          resources:
            {{- toYaml .Values.resources | nindent 12 }}
          env:
            {{- range $key, $value := .Values.env }}
            - name: {{ $key }}
              value: {{ $value | quote }}
            {{- end }}
          envFrom:

            # global secrets
            {{- range .Values.global.secretRefs }}
            - secretRef:
                name: {{ . }}
            {{- end }}

            # service secrets
            {{- range .Values.secretRefs }}
            - secretRef:
                name: {{ . }}
            {{- end }}

            # global configs
            {{- range .Values.global.configMaps }}
            - configMapRef:
                name: {{ . }}
            {{- end }}
            {{- range .Values.configMaps }}
            - configMapRef:
                name: {{ . }}
            {{- end }}
          volumeMounts:
            {{- if .Values.configMounts }}
            {{- range .Values.configMounts }}
            - name: {{ .name }}
              mountPath: {{ .mountPath }}
            {{- end }}
            {{- end }}
      volumes:
        {{- if .Values.configMounts }}
        {{- range .Values.configMounts }}
        - name: {{ .name }}
          configMap:
            name: {{ .configMapName | default .name }}
        {{- end }}
        {{- end }}
      {{- with .Values.nodeSelector }}
      nodeSelector:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.affinity }}
      affinity:
        {{- tpl (toYaml .) $ | nindent 8 }}
      {{- end }}
      {{- with .Values.tolerations }}
      tolerations:
        {{- toYaml . | nindent 8 }}
      {{- end }}
{{- end }}
