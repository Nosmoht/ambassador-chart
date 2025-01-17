{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "ambassador.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "ambassador.fullname" -}}
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
Create chart namespace based on override value.
*/}}
{{- define "ambassador.namespace" -}}
{{- if .Values.namespaceOverride -}}
{{- .Values.namespaceOverride -}}
{{- else -}}
{{- .Release.Namespace -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "ambassador.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "ambassador.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "ambassador.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the RBAC to use
*/}}
{{- define "ambassador.rbacName" -}}
{{ default (include "ambassador.fullname" .) .Values.rbac.nameOverride }}
{{- end -}}

{{/*
Define the http port of the Ambassador service
*/}}
{{- define "ambassador.servicePort" -}}
{{- range .Values.service.ports -}}
{{- if (eq .name "http") -}}
{{ default .port }}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Define RBAC apiVersion
*/}}
{{- define "ambassador.rbacAPIVersion" -}}
{{- if .Capabilities.APIVersions.Has "rbac.authorization.k8s.io/v1" -}}
{{ "rbac.authorization.k8s.io/v1" }}
{{- else -}}
{{ "rbac.authorization.k8s.io/v1beta1" }}
{{- end -}}
{{- end -}}

{{/*
Define PodDisruptionBudget apiVersion
*/}}
{{- define "ambassador.podDisruptionBudgetAPIVersion" -}}
{{- if .Capabilities.APIVersions.Has "poddisruptionbudgets.policy/v1" -}}
{{ "policy/v1" }}
{{- else -}}
{{ "policy/v1beta1" }}
{{- end -}}
{{- end -}}
