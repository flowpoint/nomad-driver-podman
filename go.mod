module github.com/hashicorp/nomad-driver-podman

go 1.14

replace (
	github.com/docker/docker v1.13.1 => github.com/docker/docker v0.7.3-0.20181219122643-d1117e8e1040
	github.com/godbus/dbus => github.com/godbus/dbus v5.0.1+incompatible

	github.com/opencontainers/runc v0.1.1 => github.com/opencontainers/runc v1.0.0-rc2.0.20181210164344-f5b99917df9f
	launchpad.net/gocheck => github.com/go-check/check v0.0.0-20140225173054-eb6ee6f84d0a
)

require (
	github.com/StackExchange/wmi v0.0.0-20190523213315-cbe66965904d // indirect
	github.com/armon/circbuf v0.0.0-20150827004946-bbbad097214e
	github.com/containers/image/v5 v5.11.1
	github.com/distribution/distribution v2.7.1+incompatible // indirect
	github.com/docker/distribution v2.7.1+incompatible
	github.com/docker/go-metrics v0.0.1 // indirect
	github.com/go-ole/go-ole v1.2.4 // indirect
	github.com/hashicorp/go-hclog v0.14.1
	github.com/hashicorp/nomad v1.0.4-0.20210415141937-ee9bb3cc4f40
	github.com/hashicorp/nomad/api v0.0.0-20210415141937-ee9bb3cc4f40
	github.com/juju/errors v0.0.0-20180806074554-22422dad46e1 // indirect
	github.com/juju/loggo v0.0.0-20190526231331-6e530bcce5d8 // indirect
	github.com/juju/testing v0.0.0-20190613124551-e81189438503 // indirect
	github.com/mattn/go-colorable v0.1.7 // indirect
	github.com/mitchellh/go-ps v1.0.0 // indirect
	github.com/onsi/ginkgo v1.13.0 // indirect
	github.com/opencontainers/runtime-spec v1.0.3-0.20200929063507-e6143ca7d51d
	github.com/stretchr/testify v1.7.0
	golang.org/x/oauth2 v0.0.0-20200107190931-bf48bf16ab8d // indirect
	gopkg.in/mgo.v2 v2.0.0-20180705113604-9856a29383ce // indirect

)
