#!/usr/bin/env bash
#
# Script variables
#
project_location=""
environment=""
log_location="/var/log/"
verbose=''
stacktrace=''
clean=''
assemble=''
quiet=''
port='8080'
start_server='false'
#
# Grails/Java related
#
target_dir="build/libs/" #created by grails
java_location=$(which java)
#
# Help function
#
usage() {
    echo "***** Kerma Partners deployment script *****\n";
    echo " -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  \n";
    echo "Usage: $0 -flag1 -flag2 ... \n";
    echo " -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  \n";
    echo "Flags description \n";
    echo " -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  \n";
    echo "Flag \tValue \tDescription"
    echo "-e \tENV \tdev,prod ";
    echo "-l \tLOG \tLogs location";
    echo "-p \tPORT \tPort to be used(8080 default)";
    echo "-h \tHOME \tProject location";
    echo ""
    echo "-r \t \tStarts embedded tomcat";
    echo "-s \t \tEnables stacktrace for war creation";
    echo "-v \t \tEnables verbose for war creation";
    echo "-q \t \tQuiet execution";
    echo "-a \t \tAssemble the project";
    echo "-c \t \tCleans the project";
    exit 1;
}

while getopts 'e:l:p:h:svrcaq' flag; do
  case "${flag}" in
    e) environment="${OPTARG}" ;;
    l) log_location="${OPTARG}";;
    h) project_location="${OPTARG}" ;;
    p) port="${OPTARG}";;
    r) start_server="true";;
    s) stacktrace='--stacktrace' ;;
    v) verbose='--verbose' ;;
    a) assemble='assemble';;
    c) clean='clean' ;;
    q) quiet='-q';;
    *) usage;;
  esac
done
#
# Commands to be executed
#
gradle_location="${project_location}/gradlew $quiet"
gradle_clean="$gradle_location clean"
run_war="$java_location -jar kerma-partners-backend-*.war"
#
# Entering the project's home
#
cd "$project_location"
#
# Setting environment for running/creating jar
#
if [ "$environment" = "dev" ] || [ "$environment" = "prod" ]; then
    gradle_assemble="$gradle_location -Dgrails.env=$environment $assemble $verbose $stacktrace"
fi

#
# Show the variables used
#
echo "**************************************************************************************************************"
echo "------------------ Variables ---------------------------"
echo "> USER: $(whoami)"
echo "> PROJECT_LOCATION: $project_location"
echo "> LOG_LOCATION: $log_location"
echo "> ENVIRONMENT: $environment"
echo "> GRADLE_LOCATION: $gradle_location"
echo "> JAVA_LOCATION: $java_location"
echo "------------------ Flags -------------------------------"
echo "> VERBOSE: $verbose"
echo "> START SERVER: $start_server"
echo "> STACKTRACE: $stacktrace"
echo "> ASSEMBLE: $assemble"
echo "> CLEAN: $clean"
echo "> QUIET: $quiet"
echo "--------------------------------------------------------"
echo "**************************************************************************************************************"

if [ "$clean" = "clean" ]; then
    echo "> GRADLE_CLEAN: $gradle_clean"
    eval $gradle_clean
    echo "********************* Project was cleaned ..."
fi

if [ "$assemble" = "assemble" ]; then
    echo "> GRADLE_ASSEMBLE: $gradle_assemble"
    eval $gradle_assemble
    echo "********************* War file has been generated ..."
fi

if [ "$start_server" = "true" ]; then
    run_war="SERVER_PORT=$port $run_war"
    echo "> RUN_WAR: $run_war"
    export LOG_LOCATION="$log_location"
    cd "$target_dir"
    #
    # set the log home
    #
    echo "******************* Starting server ...."
    eval $run_war
    exit 1
fi