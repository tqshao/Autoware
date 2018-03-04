#!/usr/bin/env julia

using RobotOS
@rosimport geometry_msgs.msg: Point, Pose, Pose2D, PoseStamped, Vector3
@rosimport std_srvs.srv: Empty, SetBool
@rosimport nav_msgs.srv.GetPlan

@rosimport gazebo_msgs.msg: ModelState
@rosimport gazebo_msgs.srv: SetModelState, GetModelState, GetWorldProperties

rostypegen()
using geometry_msgs.msg
using std_srvs.srv
using nav_msgs.srv.GetPlan
using gazebo_msgs.msg
using gazebo_msgs.srv
using PyCall
@pyimport tf.transformations as tf

# TODO
# 1) check to see if model is paused

function loop(set_state)
    loop_rate = Rate(5.0)

    #modelName = RobotOS.get_param("obstacle_name")
    modelName = "obstacles"

    while !is_shutdown()

        # Set the state of the Gazebo model
        ss = SetModelStateRequest()
        ss.model_state.model_name = modelName
        ss.model_state.twist.linear.x = 20
        ss.model_state.pose.position.x=0
        println("Calling 'gazebo/set_model_state' service...")
        ss_r = set_state(ss)

        if !ss_r.success
            error(string(" calling /gazebo/set_model_state service: ", ss_r.status_message))
        end
        rossleep(loop_rate)
    end
end

function main()
    init_node("rosjl_move_obstacles")

    RobotOS.set_param("mavs/bool/init_move_obstalces",false)

    # Set up service to set Gazebo model state
    const set_state = ServiceProxy("/gazebo/set_model_state", SetModelState)
    println("Waiting for 'gazebo/set_model_state' service...")
    wait_for_service("gazebo/set_model_state")

    loop(set_state)
end

if ! isinteractive()
    main()
end
