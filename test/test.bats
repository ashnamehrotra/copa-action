#!/usr/bin/env bats

load helpers

@test "Check patched image exists" {
    docker images
    id=$(docker images --quiet 'openpolicyagent/opa:0.46.0-patched')
    docker pull openpolicyagent/opa:0.46.0-patched
    assert_not_equal "$id" ""
}

@test "Check output.json exists" {
    run test -f /tmp/output.json
    [ "$status" -eq 0 ]
}

@test "Run trivy on patched image" {
    docker context use "setup-docker-action"
    run trivy image --exit-code 1 --vuln-type os --ignore-unfixed -f json -o opa.0.46.0-patched.json 'docker.io/openpolicyagent/opa:0.46.0-patched'
    [ "$status" -eq 0 ]
    vulns=$(jq 'if .Results then [.Results[] | select(.Class=="os-pkgs" and .Vulnerabilities!=null) | .Vulnerabilities[]] | length else 0 end' opa.0.46.0-patched.json)
    assert_equal "$vulns" "0"
}