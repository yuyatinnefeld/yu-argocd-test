{{- define "default.annotations" -}}
openshift.io/description: "create openshift secrets for multi-mesh cluster communication"
{{- end -}}

{{- define "default.labels.appsys" -}}
servicemesh.bankenit.de/project: ossm2x-eso-pushsecret
app.kubernetes.io/part-of: ossm2x-eso
{{- end  -}}
