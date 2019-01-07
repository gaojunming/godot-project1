# 继承于Node2D
extends Node2D

# 常量，表示速度（像素）
const SPEED = 200
const SKY_SPEED=50
# 定义一些变量，不需要类型
var maxX = 600 # 角色运动右边界
var minX = 0 # 角色运动左边界
#var knight # 骑士节点
# onready关键词使变量在场景加载完后赋值，保证不为null
# 效果和上一篇在 _ready() 方法中初始化一样
onready var knight = self.get_node("Knight")
# 在Godot中$符号可以直接加子节点名字获得子节点对象
# $Sky1相当于self.get_node("Sky1")
onready var sky1 = $sky1
onready var sky2 = $sky2
# 节点进入场景开始时调用此方法，常用作初始化
func _ready():
    # 获取节点并赋值给变量knight
    #knight = self.get_node("Knight")
    maxX -= knight.frames.get_frame('idle', 0).get_size().x / 2
    minX += knight.frames.get_frame('idle', 0).get_size().x / 2

# 每一帧运行此方法，delta表示每帧间隔
func _process(delta):
	# 移动背景天空位置，生成滚动动画
    updateSkyAnimation(SKY_SPEED * delta)
    # Input表示设备输入，这里D和右光标表示往右动
    if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT):
        moveKnightX(1, SPEED, delta)
        return # 有设备输入，直接返回
    elif Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT):
        moveKnightX(-1, SPEED, delta)
        return # 有设备输入，直接返回
    
    # 没有键盘控制，让骑士动画设置为idle状态
    if knight.animation != 'idle':
        knight.animation = 'idle'
# 移动背景天空位置，生成滚动动画
func updateSkyAnimation(speed):
    # 移动，更新背景的位置
    sky1.position.x -= speed
    sky2.position.x -= speed
    # 如果滚动到最左边，那么移动到右边来
    if sky1.position.x <= -1200:
        sky1.position.x += 2400
    elif sky2.position.x <= -1200:
        sky2.position.x += 2400
# 自定义函数，direction表示方向，speed表示速度，delta是帧间隔
func moveKnightX(direction, speed, delta):
	# 控制骑士移动，让骑士动画为run状态，跑起来
    if knight.animation != 'run':
        knight.animation = 'run'
    if direction == 0:
        return
    # position属性为节点当前置，Vector2向量简单乘法
    knight.position += Vector2(SPEED, 0) * delta * direction
    print('position: ', knight.position)
    # 越界检测
    if knight.position.x > maxX:
        knight.position = Vector2(maxX, knight.position.y)
    elif knight.position.x < minX:
        knight.position = Vector2(minX, knight.position.y)
    knight.scale = Vector2(direction, 1)