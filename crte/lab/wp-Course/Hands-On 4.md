Task
•  Enumerate all domains in the techcorp.local forest.
•  Map the trusts of the us.techcorp.local domain.
•  Map external trusts in techcorp.local forest.
•  Identify external trusts of us domain. Can you enumerate trusts for a trusting forest?


# Enumerate all domains in the techcorp.local forest.

```
PS C:\ad\Tools> Get-NetForestDomain -Forest  techcorp.local


Forest                  : techcorp.local
DomainControllers       : {Techcorp-DC.techcorp.local}
Children                : {us.techcorp.local}
DomainMode              : Unknown
DomainModeLevel         : 7
Parent                  :
PdcRoleOwner            : Techcorp-DC.techcorp.local
RidRoleOwner            : Techcorp-DC.techcorp.local
InfrastructureRoleOwner : Techcorp-DC.techcorp.local
Name                    : techcorp.local

Forest                  : techcorp.local
DomainControllers       : {US-DC.us.techcorp.local}
Children                : {}
DomainMode              : Unknown
DomainModeLevel         : 7
Parent                  : techcorp.local
PdcRoleOwner            : US-DC.us.techcorp.local
RidRoleOwner            : US-DC.us.techcorp.local
InfrastructureRoleOwner : US-DC.us.techcorp.local
Name                    : us.techcorp.local
```

# Map the trusts of the us.techcorp.local domain.


```
PS C:\ad\Tools> Get-NetDomainTrust -Domain us.techcorp.local


SourceName      : us.techcorp.local
TargetName      : techcorp.local
TrustType       : WINDOWS_ACTIVE_DIRECTORY
TrustAttributes : WITHIN_FOREST
TrustDirection  : Bidirectional
WhenCreated     : 7/5/2019 7:48:23 AM
WhenChanged     : 10/30/2022 9:03:14 PM

SourceName      : us.techcorp.local
TargetName      : eu.local
TrustType       : WINDOWS_ACTIVE_DIRECTORY
TrustAttributes : FILTER_SIDS
TrustDirection  : Bidirectional
WhenCreated     : 7/13/2019 11:17:35 AM
WhenChanged     : 10/30/2022 9:16:17 PM
```

us.techcorp.local跟techcorp.local是双向信任

us.techcorp.local跟eu.local是双向信任

# Map external trusts in techcorp.local forest.

```
PS C:\ad\Tools> Get-NetForestTrust -Forest techcorp.local


TopLevelNames            : {usvendor.local}
ExcludedTopLevelNames    : {}
TrustedDomainInformation : {usvendor.local}
SourceName               : techcorp.local
TargetName               : usvendor.local
TrustType                : Forest
TrustDirection           : Bidirectional

TopLevelNames            : {bastion.local}
ExcludedTopLevelNames    : {}
TrustedDomainInformation : {bastion.local}
SourceName               : techcorp.local
TargetName               : bastion.local
TrustType                : Forest
TrustDirection           : Inbound
```

techcorp.local跟usvendor.local是双向外部信任

techcorp.local跟bastion.local是入站信任

# Identify external trusts of us domain. Can you enumerate trusts for a trusting forest?

```
PS C:\ad\Tools>  Get-ForestTrust -Forest eu.local


TopLevelNames            : {euvendor.local}
ExcludedTopLevelNames    : {}
TrustedDomainInformation : {euvendor.local}
SourceName               : eu.local
TargetName               : euvendor.local
TrustType                : Forest
TrustDirection           : Bidirectional
```