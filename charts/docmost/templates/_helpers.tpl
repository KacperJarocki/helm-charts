{{/*
Expand the name of the chart.
*/}}
{{- define "docmost.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "docmost.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "docmost.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "docmost.labels" -}}
helm.sh/chart: {{ include "docmost.chart" . }}
{{ include "docmost.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "docmost.selectorLabels" -}}
app.kubernetes.io/name: {{ include "docmost.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "docmost.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "docmost.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "docmost.appUrl" -}}
{{- $default := "http://localhost:3000" -}}

{{- if .Values.ingress.enabled -}}
  {{- $host := "" -}}
  {{- if and .Values.ingress.hosts (gt (len .Values.ingress.hosts) 0) -}}
    {{- $h0 := index .Values.ingress.hosts 0 -}}
    {{- if and $h0 (hasKey $h0 "host") -}}
      {{- $host = (default "" $h0.host) -}}
    {{- end -}}
  {{- end -}}

  {{- if ne $host "" -}}
    {{- $scheme := "http" -}}
    {{- if and .Values.ingress.tls (gt (len .Values.ingress.tls) 0) -}}
      {{- $tls0 := index .Values.ingress.tls 0 -}}
      {{- if and $tls0 (hasKey $tls0 "secretName") (ne (default "" $tls0.secretName) "") -}}
        {{- $scheme = "https" -}}
      {{- end -}}
    {{- end -}}
    {{- printf "%s://%s" $scheme $host -}}
  {{- else -}}
    {{- $default -}}
  {{- end -}}
{{- else -}}
  {{- $default -}}
{{- end -}}
{{- end -}}
