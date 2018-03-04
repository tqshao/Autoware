#include <ros/ros.h>
#include <tf/transform_broadcaster.h>
#include "gazebo_msgs/ModelStates.h"

std::string frame_name;

void poseCallback(const gazebo_msgs::ModelStates::ConstPtr& msg){
  static tf::TransformBroadcaster br;
  tf::Transform transform;
  transform.setOrigin( tf::Vector3(msg->pose[1].position.x, msg->pose[1].position.y,
                                   msg->pose[1].position.z) );
  tf::Quaternion q(msg->pose[1].orientation.x, msg->pose[1].orientation.y,
                   msg->pose[1].orientation.z, msg->pose[1].orientation.w);

  // q.setRPY(0, 0, msg->theta);
  // transform.setRotation(q);
  br.sendTransform(tf::StampedTransform(transform, ros::Time::now(), "world", frame_name));
}

int main(int argc, char** argv){
  ros::init(argc, argv, "map_tf_broadcaster");
  if (argc != 2){ROS_ERROR("need frame name as argument"); return -1;};
  frame_name = argv[1];

  ros::NodeHandle node;
  ros::Subscriber sub = node.subscribe("/gazebo/model_states", 100, &poseCallback);

  ros::spin();
  return 0;
};
