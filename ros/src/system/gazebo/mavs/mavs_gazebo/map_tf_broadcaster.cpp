#include <ros/ros.h>
#include <tf/transform_broadcaster.h>
#include "gazebo_msgs/ModelStates.h"

std::string frame_name;

void poseCallback(const gazebo_msgs::ModelStates::ConstPtr& msg){
  static tf::TransformBroadcaster br;
  tf::Transform transform;
  int i = 0;
  for(; i<msg->model_name.size(); i++){
    if (msg->model_name[i] == "hmmwv") break;
  }
  std::printf("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
  transform.setOrigin( tf::Vector3(msg->pose[i].position.x, msg->pose[i].position.y,
                                   msg->pose[i].position.z) );
  tf::Quaternion q(msg->pose[i].orientation.x, msg->pose[i].orientation.y,
                   msg->pose[i].orientation.z, msg->pose[i].orientation.w);

  // q.setRPY(0, 0, msg->theta);
  // transform.setRotation(q);
  br.sendTransform(tf::StampedTransform(transform, ros::Time::now(), "world", frame_name));
}

int main(int argc, char** argv){
  ros::init(argc, argv, "map_tf_broadcaster");
  if (argc != 2){ROS_ERROR("need frame name as argument"); return -1;};
  frame_name = argv[1];

  ros::NodeHandle node;
  ros::Subscriber sub = node.subscribe("/gazebo/model_states", 1000, &poseCallback);

  ros::spin();
  return 0;
};
