# Change this to where gen-crd-api-reference-docs is extracted
GEN_DOCS=${HOME}/gen-crd-api-reference-docs

# Change this to where the website repository is cloned.
WEBSITE_ROOT=${GOPATH}/src/github.com/kubeflow/website

# table style substitutions
TABLE_SUB='<div class=\"table-responsive\"><table class=\"table table-bordered\">'
THEAD_SUB='<thead class=\"thead-light\">'

# V1beta2
CONTENT_DIR=${WEBSITE_ROOT}/content/docs/reference/tfjob/v1beta2

echo "+++
title = \"TFJob Common\"
description = \"Reference documentation for TFJob\"
weight = 100
+++" > ${CONTENT_DIR}/common.md

${GEN_DOCS}/gen-crd-api-reference-docs -config ${WEBSITE_ROOT}/gen-api-reference/kubeflow-config.json -template-dir ${GEN_DOCS}/template -api-dir "github.com/kubeflow/tf-operator/pkg/apis/common/v1beta2" -out-file temp_common.md
cat temp_common.md >> ${CONTENT_DIR}/common.md
rm temp_common.md

sed 's/<table>/'"$TABLE_SUB"'/g' ${CONTENT_DIR}/common.md > temp_common.md
sed 's/<thead>/'"$THEAD_SUB"'/g' temp_common.md > ${CONTENT_DIR}/common.md
rm temp_common.md

echo "+++
title = \"TFJob TensorFlow\"
description = \"Reference documentation for TFJob\"
weight = 100
+++" > ${CONTENT_DIR}/tensorflow.md

${GEN_DOCS}/gen-crd-api-reference-docs -config ${WEBSITE_ROOT}/gen-api-reference/kubeflow-config.json -template-dir ${GEN_DOCS}/template -api-dir "github.com/kubeflow/tf-operator/pkg/apis/tensorflow/v1beta2" -out-file temp_tensorflow.md
cat temp_tensorflow.md >> ${CONTENT_DIR}/tensorflow.md
rm temp_tensorflow.md

sed 's/<table>/'"$TABLE_SUB"'/g' ${CONTENT_DIR}/tensorflow.md > temp_tensorflow.md
sed 's/<thead>/'"$THEAD_SUB"'/g' temp_tensorflow.md > ${CONTENT_DIR}/tensorflow.md
rm temp_tensorflow.md

# V1
CONTENT_DIR=${WEBSITE_ROOT}/content/docs/reference/tfjob/v1

echo "+++
title = \"TFJob Common\"
description = \"Reference documentation for TFJob\"
weight = 100
+++" > ${CONTENT_DIR}/common.md


${GEN_DOCS}/gen-crd-api-reference-docs -config ${WEBSITE_ROOT}/gen-api-reference/kubeflow-config.json -template-dir ${GEN_DOCS}/template -api-dir "github.com/kubeflow/tf-operator/pkg/apis/common/v1" -out-file temp_common.md
cat temp_common.md >> ${CONTENT_DIR}/common.md
rm temp_common.md

sed 's/<table>/'"$TABLE_SUB"'/g' ${CONTENT_DIR}/common.md > temp_common.md
sed 's/<thead>/'"$THEAD_SUB"'/g' temp_common.md > ${CONTENT_DIR}/common.md
rm temp_common.md

echo "+++
title = \"TFJob TensorFlow\"
description = \"Reference documentation for TFJob\"
weight = 100
+++" > ${CONTENT_DIR}/tensorflow.md

${GEN_DOCS}/gen-crd-api-reference-docs -config ${WEBSITE_ROOT}/gen-api-reference/kubeflow-config.json -template-dir ${GEN_DOCS}/template -api-dir "github.com/kubeflow/tf-operator/pkg/apis/tensorflow/v1" -out-file temp_tensorflow.md
cat temp_tensorflow.md >> ${CONTENT_DIR}/tensorflow.md
rm temp_tensorflow.md

sed 's/<table>/'"$TABLE_SUB"'/g' ${CONTENT_DIR}/tensorflow.md > temp_tensorflow.md
sed 's/<thead>/'"$THEAD_SUB"'/g' temp_tensorflow.md > ${CONTENT_DIR}/tensorflow.md
rm temp_tensorflow.md
