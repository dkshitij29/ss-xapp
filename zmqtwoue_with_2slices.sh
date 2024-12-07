# #!/bin/sh

# SLEEPINT=5;

# export SS_XAPP=`kubectl get svc -n ricxapp --field-selector metadata.name=service-ricxapp-ss-rmr -o jsonpath='{.items[0].spec.clusterIP}'`
# if [ -z "$SS_XAPP" ]; then
#     export SS_XAPP=`kubectl get svc -n ricxapp --field-selector metadata.name=service-ricxapp-ss-rmr -o jsonpath='{.items[0].spec.clusterIP}'`
# fi
# if [ -z "$SS_XAPP" ]; then
#     echo "ERROR: failed to find ss-xapp nbi service; aborting!"
#     exit 1
# fi

# echo SS_XAPP=$SS_XAPP ; echo

# echo Listing NodeBs: ; echo
# curl -i -X GET http://${SS_XAPP}:8000/v1/nodebs ; echo ; echo
# echo Listing Slices: ; echo
# curl -i -X GET http://${SS_XAPP}:8000/v1/slices ; echo ; echo
# echo Listing Ues: ; echo
# curl -i -X GET http://${SS_XAPP}:8000/v1/ues ; echo ; echo

# sleep $SLEEPINT

# echo "Creating NodeB (id=1):" ; echo
# curl -i -X POST -H "Content-type: application/json" -d '{"type":"eNB","id":411,"mcc":"001","mnc":"01"}' http://${SS_XAPP}:8000/v1/nodebs ; echo ; echo
# echo Listing NodeBs: ; echo
# curl -i -X GET http://${SS_XAPP}:8000/v1/nodebs ; echo ; echo

# sleep $SLEEPINT

# echo "Creating Slice (name=fast-1)": ; echo
# curl -i -X POST -H "Content-type: application/json" -d '{"name":"fast-1","allocation_policy":{"type":"proportional","share":1024}}' http://${SS_XAPP}:8000/v1/slices ; echo ; echo
# echo Listing Slices: ; echo
# curl -i -X GET http://${SS_XAPP}:8000/v1/slices ; echo ; echo

# sleep $SLEEPINT

# echo "Creating Slice (name=fast-2)": ; echo
# curl -i -X POST -H "Content-type: application/json" -d '{"name":"fast-1","allocation_policy":{"type":"proportional","share":1024}}' http://${SS_XAPP}:8000/v1/slices ; echo ; echo
# echo Listing Slices: ; echo
# curl -i -X GET http://${SS_XAPP}:8000/v1/slices ; echo ; echo

# sleep $SLEEPINT

# echo "Binding Slice to NodeB (name=fast-1):" ; echo

# curl -i -X POST http://${SS_XAPP}:8000/v1/nodebs/enB_macro_001_001_0019b0/slices/fast-1 ; echo ; echo
# echo "Getting NodeB (name=enB_macro_001_001_0019b0):" ; echo
# curl -i -X GET http://${SS_XAPP}:8000/v1/nodebs/enB_macro_001_001_0019b0 ; echo ; echo

# sleep $SLEEPINT

# echo "Binding Slice to NodeB (name=fast-2):" ; echo

# curl -i -X POST http://${SS_XAPP}:8000/v1/nodebs/enB_macro_001_001_0019b0/slices/fast-2 ; echo ; echo
# echo "Getting NodeB (name=enB_macro_001_001_0019b0):" ; echo
# curl -i -X GET http://${SS_XAPP}:8000/v1/nodebs/enB_macro_001_001_0019b0 ; echo ; echo

# sleep $SLEEPINT

# echo "Creating Ue (ue=001010123456789)" ; echo
# curl -i -X POST -H "Content-type: application/json" -d '{"imsi":"001010123456789"}' http://${SS_XAPP}:8000/v1/ues ; echo ; echo
# echo Listing Ues: ; echo
# curl -i -X GET http://${SS_XAPP}:8000/v1/ues ; echo ; echo

# sleep $SLEEPINT

# echo "Creating Ue (ue=001010123456780)" ; echo
# curl -i -X POST -H "Content-type: application/json" -d '{"imsi":"001010123456780"}' http://${SS_XAPP}:8000/v1/ues ; echo ; echo
# echo Listing Ues: ; echo
# curl -i -X GET http://${SS_XAPP}:8000/v1/ues ; echo ; echo

# sleep $SLEEPINT

# echo "Binding Ue to Slice fast (imsi=001010123456789):" ; echo
# curl -i -X POST http://${SS_XAPP}:8000/v1/slices/fast-1/ues/001010123456789 ; echo ; echo
# echo "Getting Slice (name=fast):" ; echo
# curl -i -X GET http://${SS_XAPP}:8000/v1/slices/fast-1 ; echo ; echo

# echo "Binding Ue (imsi=001010123456780):" ; echo
# curl -i -X POST http://${SS_XAPP}:8000/v1/slices/fast-2/ues/001010123456780 ; echo ; echo
# echo "Getting Slice (name=fast):" ; echo
# curl -i -X GET http://${SS_XAPP}:8000/v1/slices/fast-2; echo ; echo

# #creation of nodeb, ues, slices and binding

# echo " Throttle the Targeted Slice "
# curl -i -X PUT -H "Content-type: application/json" -d '{
#     "allocation_policy": {
#         "type": "proportional",
#         "share": 0,
#         "throttle": true,
#         "throttle_threshold": -1,
#         "throttle_period": 1800,
#         "throttle_share": 10,
#         "throttle_target": 1
#     }
# }' http://${SS_XAPP}:8000/v1/slices/fast-1

# # complete denial for share: 0
# # echo " Throttle the Targeted Slice "
# # curl -i -X PUT -H "Content-type: application/json" -d '{
# #     "allocation_policy": {
# #         "type": "proportional",
# #         "share": 0,
# #         "throttle": true,
# #         "throttle_threshold": -1,
# #         "throttle_period": 1800,
# #         "throttle_share": 10,
# #         "throttle_target": 1
# #     }
# # }' http://${SS_XAPP}:8000/v1/slices/fast-1


#!/bin/sh

SLEEPINT=5;

echo "Starting the script..."
echo "Fetching the SS_XAPP service IP..."

export SS_XAPP=`kubectl get svc -n ricxapp --field-selector metadata.name=service-ricxapp-ss-rmr -o jsonpath='{.items[0].spec.clusterIP}'`
if [ -z "$SS_XAPP" ]; then
    export SS_XAPP=`kubectl get svc -n ricxapp --field-selector metadata.name=service-ricxapp-ss-rmr -o jsonpath='{.items[0].spec.clusterIP}'`
fi
if [ -z "$SS_XAPP" ]; then
    echo "ERROR: Failed to find ss-xapp NBI service; aborting!"
    exit 1
fi

echo "SS_XAPP service IP: $SS_XAPP"
echo

echo "Listing NodeBs:"
curl -i -X GET http://${SS_XAPP}:8000/v1/nodebs
echo

echo "Listing Slices:"
curl -i -X GET http://${SS_XAPP}:8000/v1/slices
echo

echo "Listing UEs:"
curl -i -X GET http://${SS_XAPP}:8000/v1/ues
echo

sleep $SLEEPINT

echo "Creating NodeB (id=411):"
curl -i -X POST -H "Content-type: application/json" -d '{"type":"eNB","id":411,"mcc":"001","mnc":"01"}' http://${SS_XAPP}:8000/v1/nodebs
echo

echo "Verifying NodeB creation:"
curl -i -X GET http://${SS_XAPP}:8000/v1/nodebs
echo

sleep $SLEEPINT

echo "Creating Slice (name=fast-1):"
curl -i -X POST -H "Content-type: application/json" -d '{"name":"fast-1","allocation_policy":{"type":"proportional","share":1024}}' http://${SS_XAPP}:8000/v1/slices
echo

echo "Verifying Slice creation (fast-1):"
curl -i -X GET http://${SS_XAPP}:8000/v1/slices
echo

sleep $SLEEPINT

echo "Creating Slice (name=fast-2):"
curl -i -X POST -H "Content-type: application/json" -d '{"name":"fast-2","allocation_policy":{"type":"proportional","share":1024}}' http://${SS_XAPP}:8000/v1/slices
echo

echo "Verifying Slice creation (fast-2):"
curl -i -X GET http://${SS_XAPP}:8000/v1/slices
echo

sleep $SLEEPINT

echo "Binding Slice (fast-1) to NodeB (enB_macro_001_001_0019b0):"
curl -i -X POST http://${SS_XAPP}:8000/v1/nodebs/enB_macro_001_001_0019b0/slices/fast-1
echo

echo "Getting NodeB details (enB_macro_001_001_0019b0):"
curl -i -X GET http://${SS_XAPP}:8000/v1/nodebs/enB_macro_001_001_0019b0
echo

sleep $SLEEPINT

echo "Binding Slice (fast-2) to NodeB (enB_macro_001_001_0019b0):"
curl -i -X POST http://${SS_XAPP}:8000/v1/nodebs/enB_macro_001_001_0019b0/slices/fast-2
echo

echo "Getting NodeB details (enB_macro_001_001_0019b0):"
curl -i -X GET http://${SS_XAPP}:8000/v1/nodebs/enB_macro_001_001_0019b0
echo

sleep $SLEEPINT

echo "Creating Ue (imsi=001010123456789):"
curl -i -X POST -H "Content-type: application/json" -d '{"imsi":"001010123456789"}' http://${SS_XAPP}:8000/v1/ues
echo

echo "Verifying Ue creation:"
curl -i -X GET http://${SS_XAPP}:8000/v1/ues
echo

sleep $SLEEPINT

echo "Creating Ue (imsi=001010123456780):"
curl -i -X POST -H "Content-type: application/json" -d '{"imsi":"001010123456780"}' http://${SS_XAPP}:8000/v1/ues
echo

echo "Verifying Ue creation:"
curl -i -X GET http://${SS_XAPP}:8000/v1/ues
echo

sleep $SLEEPINT

echo "Binding Ue (imsi=001010123456789) to Slice (fast-1):"
curl -i -X POST http://${SS_XAPP}:8000/v1/slices/fast-1/ues/001010123456789
echo

echo "Getting Slice details (fast-1):"
curl -i -X GET http://${SS_XAPP}:8000/v1/slices/fast-1
echo

echo "Binding Ue (imsi=001010123456780) to Slice (fast-2):"
curl -i -X POST http://${SS_XAPP}:8000/v1/slices/fast-2/ues/001010123456780
echo

echo "Getting Slice details (fast-2):"
curl -i -X GET http://${SS_XAPP}:8000/v1/slices/fast-2
echo

echo "Throttling the targeted Slice (fast-1):"
curl -i -X PUT -H "Content-type: application/json" -d '{
    "allocation_policy": {
        "type": "proportional",
        "share": 0,
        "throttle": true,
        "throttle_threshold": -1,
        "throttle_period": 1800,
        "throttle_share": 10,
        "throttle_target": 1
    }
}' http://${SS_XAPP}:8000/v1/slices/fast-1
echo

echo "Throttling the targeted Slice (fast-1):"
curl -i -X PUT -H "Content-type: application/json" -d '{
    "allocation_policy": {
        "type": "proportional",
        "share": 1024,
        "throttle": false,
        "throttle_threshold": -1,
        "throttle_period": 1800,
        "throttle_share": 10,
        "throttle_target": 1
    }
}' http://${SS_XAPP}:8000/v1/slices/fast-1
echo

echo "Script completed successfully!"