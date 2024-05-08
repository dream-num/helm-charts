{{/*
Expand the name of the chart.
*/}}
{{- define "univer-workspace-entry.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "univer-workspace-entry.fullname" -}}
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
{{- define "univer-workspace-entry.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "univer-workspace-entry.labels" -}}
helm.sh/chart: {{ include "univer-workspace-entry.chart" . }}
{{ include "univer-workspace-entry.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "univer-workspace-entry.selectorLabels" -}}
app.kubernetes.io/name: {{ include "univer-workspace-entry.name" . }}
app.kubernetes.io/instance: {{ include "univer-workspace-entry.name" . }}
{{- end }}

{{/* vim: set filetype=mustache: */}}
{{/*
Return the proper image name
{{ include "common.images.image" ( dict "image" .Values.path.to.the.image ) }}
*/}}
{{- define "common.images.image" -}}
{{- $registryName := .image.registry -}}
{{- $repositoryName := .image.repository -}}
{{- $separator := ":" -}}
{{- $termination := .image.tag | toString -}}
{{- if .image.digest }}
    {{- $separator = "@" -}}
    {{- $termination = .image.digest | toString -}}
{{- end -}}
{{- if $registryName }}
    {{- printf "%s/%s%s%s" $registryName $repositoryName $separator $termination -}}
{{- else -}}
    {{- printf "%s%s%s"  $repositoryName $separator $termination -}}
{{- end -}}
{{- end -}}

{{- define "univer-workspace-entry.istio.labels" -}}
version: {{ .Values.istio.version | quote }}
{{- end }}