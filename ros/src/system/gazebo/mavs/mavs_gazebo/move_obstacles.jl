#!/usr/bin/env julia

using RobotOS
@rosimport geometry_msgs.msg: Twist

rostypegen()
using geometry_msgs.msg
import geometry_msgs.msg: Twist

# TODO
# 1) check to see if model is paused
# 2) pass config file names

function loop(pub, obs_num)
    loop_rate = Rate(5.0)

    #modelName = RobotOS.get_param("obstacle_name")
    modelName = "obstacle"

    RobotOS.set_param("mavs/bool/init_move_obstacles",true)

    while !is_shutdown()

        for i in 1:obs_num
            cmd = Twist()
            cmd.linear.x = RobotOS.get_param("mavs/obs/vx")[i]
            cmd.linear.y = RobotOS.get_param("mavs/obs/vy")[i]
            publish(pub[i], cmd)
        end
        rossleep(loop_rate)
    end
end

function main()
    init_node("rosjl_move_obstacles")

    RobotOS.set_param("mavs/bool/init_move_obstacles",false)

    obs_num = RobotOS.get_param("mavs/obs/num")

    pub = Array{Publisher{Twist}}(obs_num)

    for i in 1:obs_num
        pub[i] = Publisher{Twist}(string("Obstacle",i,"/cmd_vel"), queue_size = 10)
    end

    loop(pub, obs_num)
end

if ! isinteractive()
    main()
end
