{{/* 生成唯一名称的 helper 函数 */}}
{{- define "swagger-ui.fullname" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name -}}
{{- end -}}