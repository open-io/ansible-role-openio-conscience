#! /usr/bin/env bats

# Variable SUT_ID should be set outside this script and should contain the ID
# number of the System Under Test.

# Tests
@test 'Conscience up' {
  run bash -c "docker exec -ti ${SUT_ID} gridinit_cmd status TRAVIS-conscience-0"
  echo "output: "$output
  echo "status: "$status
  [[ "${status}" -eq "0" ]]
  [[ "${output}" =~ " UP " ]]
}


@test 'Conscience alive' {
  run bash -c "docker exec -ti ${SUT_ID} oio-tool ping 172.17.0.2:6000"
  echo "output: "$output
  echo "status: "$status
  [[ "${status}" -eq "0" ]]
  [[ "${output}" =~ "PING OK" ]]
}


@test 'Conscience stat' {
  run bash -c "docker exec -ti ${SUT_ID} bash -c 'oio-tool stat 172.17.0.2:6000 |head -n 1'"
  echo "output: "$output
  echo "status: "$status
  [[ "${status}" -eq "0" ]]
  [[ "${output}" =~ "172.17.0.2:6000" ]]
}

@test 'Conscience multiple' { 
  run bash -c "docker exec -ti ${SUT_ID} cat /etc/oio/sds/TRAVIS/conscience-0/conscience-0.conf" 
  echo "output: "$output 
  echo "status: "$status 
  [[ "${status}" -eq "0" ]] 
  [[ "${output}" =~ "param_hub.me=tcp://172.17.0.2:6600" ]] && [[ "${output}" =~ "param_hub.group=tcp://172.17.0.3:6600,tcp://172.17.0.4:6600" ]]
} 

@test 'Request throught oioproxy' {
  run bash -c "curl -s http://172.17.0.2:6006/v3.0/TRAVIS/conscience/list?type=meta0"
  echo "output: "$output
  echo "status: "$status
  [[ "${status}" -eq "0" ]]
  [[ "${output}" =~ "\/var\/lib\/oio\/sds\/TRAVIS\/meta0-0" ]]
}

@test 'Conscience pool' {  
  run bash -c "docker exec -ti ${SUT_ID} cat /etc/oio/sds/TRAVIS/conscience-0/conscience-0-services.conf"  
  echo "output: "$output  
  echo "status: "$status  
  [[ "${status}" -eq "0" ]]  
  [[ "${output}" =~ "pool:rawx21" ]] && [[ "${output}" =~ 'targets=2,rawx-europe,rawx;1,rawx-asia,rawx' ]] && [[ "${output}" =~ "min_dist=2" ]]
}  
