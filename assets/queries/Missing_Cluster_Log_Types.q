package Cx

#CxPragma "$.resource.aws_eks_cluster"

#Amazon EKS control plane logging don't enabled for all log types
#https://www.terraform.io/docs/providers/aws/r/eks_cluster.html

result [ getMetadata({"id" : input.All[i].CxId, "data" : [existing_log_types_set], "search": "enabled_cluster_log_types"}) ] {
	required_log_types_set = { "api", "audit", "authenticator", "controllerManager", "scheduler"  }
    logs := input.All[i].resource.aws_eks_cluster[_].enabled_cluster_log_types    
    existing_log_types_set := {x | x = logs[_]}
    existing_log_types_set & required_log_types_set != required_log_types_set
}


getMetadata(id) = res {
	some cnt
    input.All[cnt].CxId = id.id
    res := {
        "id" : input.All[cnt].CxId,
        "file" : input.All[cnt].CxFile,
        "name" : "Missing cluster log types",
        "severity": "Low",
        "cnt" : cnt,
        "search": id.search,
        "data" : id.data
    }
}

