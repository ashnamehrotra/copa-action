#!/bin/sh

image=$1
report=$2
patched_tag=$3
timeout=$4
output_file=$5
format=$6
buildkitd_container=$7


# parse image into image name
image_no_tag=$(echo "$image" | cut -d':' -f1)

# check if output_file has been set
if [ -z "$output_file" ]
then
    output=""
else
    output="--format $format --output ./data/"$output_file""
fi

# check if buildkitd container is set
if [ -z "$buildkitd_container" ]
then
    buildkitd="--addr buildx://copa-action"
else
    buildkitd="--addr tcp://127.0.0.1:8888"
fi

# debugging
echo "final command: copa patch -i $image -r ./data/"$report" -t $patched_tag $buildkitd --timeout $timeout $output"
copa_output=$(copa patch -i "$image" -r ./data/"$report" -t "$patched_tag" $buildkitd --timeout $timeout $output;)
echo "COPA OUTPUT"
echo "$copa_output

# run copa to patch image
if copa patch -i "$image" -r ./data/"$report" -t "$patched_tag" $buildkitd --timeout $timeout $output;
then
    patched_image="$image_no_tag:$patched_tag"
    echo "patched-image=$patched_image" >> "$GITHUB_OUTPUT"
else
    echo "Error patching image $image with copa"
    exit 1
fi

