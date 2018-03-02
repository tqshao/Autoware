import roslaunch
package = 'mavs_gazebo'
executable = 'YOUR_SCRIPT.py'
node_name = 'YOUR_NODE_NAME'
node = roslaunch.core.Node(package=package, node_type=executable, name=node_name)
launch = roslaunch.scriptapi.ROSLaunch()
launch.start()
process = launch.launch(node)
