# Grant 'create', 'read' and 'update' permission to paths prefixed by 'secret/data/test/'

path "kv/*" {
  capabilities = [ "create", "read", "update" ]
}

path "kv2/*" {
  capabilities = [ "create", "read", "update" ]
}

path "*" {
  capabilities = [ "create", "read", "update" ]
}