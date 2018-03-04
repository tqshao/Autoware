#!/usr/bin/env julia

using RobotOS
@rosimport geometry_msgs.msg: Twist

rostypegen()
using geometry_msgs.msg
import geometry_msgs.msg: Twist

# TODO
# 1) check to see if model is paused

function loop(pub)
    loop_rate = Rate(5.0)

    #modelName = RobotOS.get_param("obstacle_name")
    modelName = "obstacles"

    while !is_shutdown()

        cmd = Twist()
        cmd.linear.x = 10
       println("Calling 'gazebo/set_model_state' service...")

        publish(pub, cmd)
        rossleep(loop_rate)
    end
end

function main()
    init_node("rosjl_move_obstacles")

    RobotOS.set_param("mavs/bool/init_move_obstalces",false)

    pub = Publisher{Twist}("cmd_vel", queue_size = 10)


    loop(pub)
end

if ! isinteractive()
    main()
end
