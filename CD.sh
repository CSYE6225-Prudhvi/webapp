#!/bin/bash

# Check if DB_USERNAME_SECRET and DB_PASSWORD_SECRET secrets are set
if [[ -z "${LAUNCH_TEMPLATE}" || -z "${ASG}" ]]; then
  echo "Required secrets not set. Aborting script."
else
  # AWS region where the launch template is located
  REGION=us-east-1

  # Name of the launch template to update
  LAUNCH_TEMPLATE_NAME="${LAUNCH_TEMPLATE}"

  # ID of the auto scaling group associated with the launch template
  AUTO_SCALING_GROUP_NAME="${ASG}"

  # New version number for the launch template
  NEW_VERSION=$(($(aws ec2 describe-launch-template-versions --region $REGION --launch-template-name $LAUNCH_TEMPLATE_NAME --query 'max_by(LaunchTemplateVersions, &VersionNumber).VersionNumber' --output text) + 1))
  AMI_ID=$(aws ec2 describe-images --owners amazon --filters "Name=name,Values=amzn2-ami-hvm-2.0.*.1-x86_64-gp2" "Name=state,Values=available" "Name=architecture,Values=x86_64" "Name=virtualization-type,Values=hvm" --query "reverse(sort_by(Images, &CreationDate))[0].ImageId" --region us-east-1 --output text)
#   ASG_ID=$(aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names $AUTO_SCALING_GROUP_NAME --query "AutoScalingGroups[0].AutoScalingGroupARN | split(':')[-1]" --output text)
  LAUNCH_TEMPLATE_ID=$(aws ec2 describe-launch-templates --region $REGION --launch-template-names $LAUNCH_TEMPLATE_NAME --query 'LaunchTemplates[0].LaunchTemplateId' --output text)

  # Create a new version of the launch template with updated user data
  aws ec2 create-launch-template-version --region $REGION --launch-template-name $LAUNCH_TEMPLATE_NAME --source-version $NEW_VERSION --launch-template-data "ImageId"=$AMI_ID

  # Update the auto scaling group with the new launch template version
  aws autoscaling update-auto-scaling-group --region $REGION --auto-scaling-group-name $AUTO_SCALING_GROUP_NAME --launch-template "LaunchTemplateId=$LAUNCH_TEMPLATE_ID,Version=$NEW_VERSION"

  # Trigger an instance refresh in the auto scaling grou
  aws autoscaling start-instance-refresh --region $REGION --auto-scaling-group-name $AUTO_SCALING_GROUP_NAME --preferences '{"InstanceWarmup":300,"MinHealthyPercentage":50}'
fi
