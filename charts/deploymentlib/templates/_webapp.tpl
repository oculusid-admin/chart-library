{{- define "deploymentlib.webapp" -}}
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Chart.Name }}
  labels:
    app: {{ .Chart.Name }}
spec:
  replicas: {{ .Values.replicaCount }}
  selector:
    matchLabels:
      app: {{ .Chart.Name }}
  template:
    metadata:
      labels:
        app: {{ .Chart.Name }}
    spec:
      containers:
      - name: {{ .Chart.Name }}
        env:
        {{- include "deploymentlib.env-variables" . | indent 8 }}
        {{- include "deploymentlib.env-variables-from-secrets" . | indent 8 }}
        image: {{ .Values.image }}:{{ $.Chart.AppVersion }}
        imagePullPolicy: IfNotPresent
        readinessProbe:
          httpGet:
            httpHeaders:
            - name: Host
              value: readinessProbe
            path: {{ .Values.readinessPath }}
            port: {{ .Values.port }}
          initialDelaySeconds: 5
          periodSeconds: 3
        livenessProbe:
          httpGet:
            httpHeaders:
            - name: Host
              value: livenessProbe
            path: {{ .Values.livenessPath }}
            port: {{ .Values.port }}
          initialDelaySeconds: 5
          periodSeconds: 3
        ports:
        - containerPort: {{ .Values.port }}
        resources:
          limits:
            {{- if .Values.limitCpu }}
            cpu: {{ .Values.limitCpu }}
            {{- end }}
            {{- if .Values.limitMemory }}
            memory: {{ .Values.limitMemory }}
            {{- end }}

      {{- if .Values.imagePullSecret }}
      imagePullSecrets:
      - name: {{ .Values.imagePullSecret }}
      {{- end }}
{{- end }}
