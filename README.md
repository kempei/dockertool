# dockertool
tiny dockertool for AWS ECR and local repos

## run.sh
Place setenv_<IMAGE> to set DOCKERENV as the below. If you use the sample, please install jq.

```
export DOCKERENV="$DOCKERENV \
-e WN_ID=$(aws ssm get-parameters --name wn_id --with-decryption | jq -r '.Parameters[].Value') \
-e WN_PASS=$(aws ssm get-parameters --name wn_pass --with-decryption | jq -r '.Parameters[].Value') \
"
```

