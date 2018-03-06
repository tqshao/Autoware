#include <ros/ros.h>
#include <tf/transform_broadcaster.h>
#include "gazebo_msgs/ModelStates.h"

std::string frame_name;

void poseCallback(const gazebo_msgs::ModelStates::ConstPtr& msg){
  static tf::TransformBroadcaster br;
  tf::Transform transform;
  int i = 0;
  for(; i<msg->model_name.size(); i++){
    ROS_INFO_STREAM(msg->model_name[i]);
    if (msg->model_name[i] == "hmmwv") break;
  }
  ROS_INFO_STREAM("aaaaaaaaaaaaaaa: "<<  i);
  transform.setOrigin( tf::Vector3(msg->pose[i].position.x, msg->pose[i].position.y,
                                   msg->pose[i].position.z) );

  tf::Quaternion q(msg->pose[i].orientation.x, msg->pose[i].orientation.y,
                   msg->pose[i].orientation.z, msg->pose[i].orientation.w);
  // normalize the quaternion
  q.normalize();

  // q.setRPY(0, 0, msg->theta);
  transform.setRotation(q);
  br.sendTransform(tf::StampedTransform(transform, ros::Time::now(), "world", frame_name));
}

int main(int argc, char** argv){
  setvbuf(stdout, NULL, _IOLBF, 4096);        //  Set line buffering
  ROS_INFO("%s","Hello World!!");
  ros::init(argc, argv, "map_tf_broadcaster");
  ROS_INFO("%s","Hello World!!");
  if (argc != 2){ROS_ERROR("needs frame name as argument"); return -1;};
  frame_name = argv[1];
  ROS_INFO("%s","Hello World!!");

  ros::NodeHandle node;
  ros::Subscriber sub = node.subscribe("/gazebo/model_states", 1000, &poseCallback);
  ros::spin();
  return 0;
};
