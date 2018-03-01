#!/usr/bin/env julia

using RobotOS
@rosimport geometry_msgs.msg: Point, Pose, Pose2D, PoseStamped, Vector3
@rosimport std_srvs.srv: Empty, SetBool
@rosimport nav_msgs.srv.GetPlan
#@rosimport mavs_control.msg: Control

@rosimport gazebo_msgs.msg: ModelState
@rosimport gazebo_msgs.srv: SetModelState, GetModelState, GetWorldProperties

rostypegen()
using geometry_msgs.msg
using std_srvs.srv
using nav_msgs.srv.GetPlan
using gazebo_msgs.msg
using gazebo_msgs.srv
#using mavs_control.msg
using PyCall
@pyimport tf.transformations as tf
#using VehicleModels # for Linear_Spline()

# TODO
# 1) check to see if model is paused
# 2) make a while loop that publishes the current message until there is a new one ready or the current one ran out -> in this case stop the vehicle
# 3) interpolate message in time, is there a while! new message

function loop(set_state,get_state)
    loop_rate = Rate(5.0)

    modelName = RobotOS.get_param("robotName")

    while !is_shutdown()

        # Get the current position of the Gazebo model
        gs = GetModelStateRequest()
        gs.model_name = modelName
        gs_r = get_state(gs)

        if !gs_r.success
            error(string(" calling /gazebo/get_model_state service: ", gs_r.status_message))
        end

        # Define position to move robot
        vehPose = gs_r.pose  # use the current position
        vehPose.position.x = gs_r.pose.position.x
        vehPose.position.y = gs_r.pose.position.y + 0.1
        # TODO allow for functionality to update based off of /state/ parameter
        #roll = 0; pitch = 0; yaw = sp_PSI[t];
        #Q = tf.quaternion_from_euler(roll, pitch, yaw)
        #vehPose.orientation.x = Q[1]
        #vehPose.orientation.y = Q[2]
        #vehPose.orientation.z = Q[3]
        #vehPose.orientation.w = Q[4]

        # Define the robot state
        ms = ModelState()
        ms.model_name = modelName
        ms.pose = vehPose

        # Set the state of the Gazebo model
        ss = SetModelStateRequest()
        ss.model_state = ms
    #    println("Calling 'gazebo/set_model_state' service...")
        ss_r = set_state(ss)

        if !ss_r.success
            error(string(" calling /gazebo/set_model_state service: ", ss_r.status_message))
        end
        rossleep(loop_rate)
    end
end

function main()
    init_node("rosjl_move_hmmwv")

    # for testing functionality drive vehicle in a straight line
    RobotOS.set_param("mavs/straight_line",true)

    # Set up service to get Gazebo model state
    const get_state = ServiceProxy("/gazebo/get_model_state", GetModelState)
    println("Waiting for 'gazebo/get_model_state' service...")
    wait_for_service("gazebo/get_model_state")

    # Set up service to set Gazebo model state
    const set_state = ServiceProxy("/gazebo/set_model_state", SetModelState)
    println("Waiting for 'gazebo/set_model_state' service...")
    wait_for_service("gazebo/set_model_state")

#    sub_control = Subscriber{Control}("/state", callback, (get_state, set_state), queue_size = 2)

    loop(set_state,get_state)
end

if ! isinteractive()
    main()
end
