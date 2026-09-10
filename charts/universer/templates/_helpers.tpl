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
{{- $sslMode := default "disable" .sslMode -}}
{{- $mysqlTLS := "" -}}
{{- if eq $sslMode "disable" -}}
{{- $mysqlTLS = "" -}}
{{- else if or (eq $sslMode "require") (eq $sslMode "verify-ca") (eq $sslMode "verify-full") -}}
{{- $mysqlTLS = "true" -}}
{{- else -}}
{{- $mysqlTLS = $sslMode -}}
{{- end -}}
{{- if eq .driver "postgresql" -}}
{{- printf "host=%s port=%v user=%s password=%s dbname=%s sslmode=%s TimeZone=Asia/Shanghai" .host .port .username .password .dbname $sslMode -}}
{{- else if eq .driver "mysql" -}}
{{- if $mysqlTLS -}}
{{- printf "%s:%s@tcp(%s:%v)/%s?charset=utf8mb4&parseTime=True&loc=Local&tls=%s" .username .password .host .port .dbname $mysqlTLS -}}
{{- else -}}
{{- printf "%s:%s@tcp(%s:%v)/%s?charset=utf8mb4&parseTime=True&loc=Local" .username .password .host .port .dbname -}}
{{- end -}}
{{- else if eq .driver "shentong" -}}
{{- printf "%s/%s@%s:%v/%s" .username .password .host .port .dbname -}}
{{- else -}}
{{ fail "unknown database driver, should use postgresql, mysql or shentong." }}
{{- end }}
{{- end }}

{{- define "universer.database.replicaDSN" -}}
{{- if .replicaHost -}}
{{- $sslMode := default "disable" .sslMode -}}
{{- $mysqlTLS := "" -}}
{{- if eq $sslMode "disable" -}}
{{- $mysqlTLS = "" -}}
{{- else if or (eq $sslMode "require") (eq $sslMode "verify-ca") (eq $sslMode "verify-full") -}}
{{- $mysqlTLS = "true" -}}
{{- else -}}
{{- $mysqlTLS = $sslMode -}}
{{- end -}}
{{- if eq .driver "postgresql" -}}
{{- printf "host=%s port=%v user=%s password=%s dbname=%s sslmode=%s TimeZone=Asia/Shanghai" .replicaHost .port .username .password .dbname $sslMode -}}
{{- else if eq .driver "mysql" -}}
{{- if $mysqlTLS -}}
{{- printf "%s:%s@tcp(%s:%v)/%s?charset=utf8mb4&parseTime=True&loc=Local&tls=%s" .username .password .replicaHost .port .dbname $mysqlTLS -}}
{{- else -}}
{{- printf "%s:%s@tcp(%s:%v)/%s?charset=utf8mb4&parseTime=True&loc=Local" .username .password .replicaHost .port .dbname -}}
{{- end -}}
{{- else if eq .driver "shentong" -}}
{{- printf "%s/%s@%s:%v/%s" .username .password .replicaHost .port .dbname -}}
{{- else -}}
{{ fail "unknown database driver, should use postgresql, mysql or shentong." }}
{{- end }}
{{- else -}}
{{- printf "" -}}
{{- end }}
{{- end }}

{{/* Render a base64-encoded Secret key only when its value is non-empty. */}}
{{- define "universer.secret.optionalKey" -}}
{{- if not (empty .value) -}}
{{ .key }}: {{ .value | toString | b64enc | quote }}
{{- end -}}
{{- end -}}

{{/* Return the existing env Secret name or the chart-managed Secret name. */}}
{{- define "universer.envSecretName" -}}
{{- default (printf "%s-env-secret" (include "universer.fullname" .)) .Values.envSecretName -}}
{{- end -}}
