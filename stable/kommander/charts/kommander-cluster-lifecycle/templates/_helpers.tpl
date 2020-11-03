{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "kommander-cluster-lifecycle.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "kommander-cluster-lifecycle.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "kommander-cluster-lifecycle.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Add Helm metadata to selector labels specifically for deployments/daemonsets/statefulsets/\s.
*/}}
{{- define "kommander-cluster-lifecycle.commonSelectorLabels" -}}
app.kubernetes.io/name: {{ include "kommander-cluster-lifecycle.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "kommander-cluster-lifecycle.commonLabels" -}}
{{- include "kommander-cluster-lifecycle.commonSelectorLabels" . }}
helm.sh/chart: {{ include "kommander-cluster-lifecycle.chart" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Self-signed certificate issuer name
*/}}
{{- define "kommander-cluster-lifecycle.selfSignedIssuerName" -}}
{{- if .Values.certificates.issuer.name -}}
{{ .Values.certificates.issuer.name }}
{{- else -}}
{{ template "kommander-cluster-lifecycle.fullname" . }}-selfsigned
{{- end -}}
{{- end -}}

{{/*
Certificate issuer name
*/}}
{{- define "kommander-cluster-lifecycle.issuerName" -}}
{{- if .Values.certificates.issuer.selfSigned -}}
{{ template "kommander-cluster-lifecycle.selfSignedIssuerName" . }}
{{- else -}}
{{ required "A valid .Values.certificates.issuer.name is required!" .Values.certificates.issuer.name }}
{{- end -}}
{{- end -}}
