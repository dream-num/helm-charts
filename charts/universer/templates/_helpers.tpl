{{/*
Expand the name of the chart.
*/}}
{{- define "universer.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "universer.fullname" -}}
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
{{- define "universer.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "universer.labels" -}}
helm.sh/chart: {{ include "universer.chart" . }}
{{ include "universer.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "universer.selectorLabels" -}}
app: {{ include "universer.name" . }}
app.kubernetes.io/name: {{ include "universer.name" . }}
{{- end }}

{{- define "universer.istio.labels" -}}
{{- if .Values.istio.enabled -}}
version: default
{{- end }}
{{- end }}

{{- define "universer.database.dsn" -}}
{{- if eq .driver "postgresql" -}}
{{- printf "host=%s port=%v user=%s password=%s dbname=%s sslmode=disable TimeZone=Asia/Shanghai" .host .port .username .password .dbname -}}
{{- else if eq .driver "mysql" -}}
{{- printf "%s:%s@tcp(%s:%v)/%s?charset=utf8mb4&parseTime=True&loc=Local" .username .password .host .port .dbname -}}
{{- else -}}
{{ fail "unknow database driver, should use postgresql or mysql." }}
{{- end }}
{{- end }}

{{- define "universer.database.replicaDSN" -}}
{{- if .replicaHost -}}
{{- if eq .driver "postgresql" -}}
{{- printf "host=%s port=%v user=%s password=%s dbname=%s sslmode=disable TimeZone=Asia/Shanghai" .replicaHost .port .username .password .dbname -}}
{{- else if eq .driver "mysql" -}}
{{- printf "%s:%s@tcp(%s:%v)/%s?charset=utf8mb4&parseTime=True&loc=Local" .username .password .replicaHost .port .dbname -}}
{{- else -}}
{{ fail "unknow database driver, should use postgresql or mysql." }}
{{- end }}
{{- else -}}
{{- printf "" -}}
{{- end }}
{{- end }}