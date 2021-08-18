# Show this message and exit.
help:
	@just list

template-deployment +ARGS='':
  helm dependency update charts/deploymentexample
  helm template charts/deploymentexample {{ARGS}}

template-ingress +ARGS='':
  helm dependency update charts/ingressexample
  helm template charts/ingressexample {{ARGS}}

template-service +ARGS='':
  helm dependency update charts/serviceexample
  helm template charts/serviceexample {{ARGS}}

template-serviceaccount +ARGS='':
  helm dependency update charts/serviceaccountexample
  helm template charts/serviceaccountexample {{ARGS}}
