# 基于WebGIS的淮河水量水质监测系统


**作者：**      Ysoup

 **CSDN博客:**[https://blog.csdn.net/Deep_rooted](https://blog.csdn.net/Deep_rooted "CSDN博客")

## 1.系统简介
### 1.1 开发背景
1. 淮河位于我国东部地区，介于长江和黄河之间，其干流流经河南、安徽、江苏三省。淮河流域地跨河南、湖北、安徽、江苏和山东五省，以废黄河为界，可以将其分为淮河水系和沂沭泗水系。
2. 淮河是洪旱灾害频发区，从古至今，治淮一直是一项重要的课题。同时，随着工业发展、城镇化提速以及人口数量的急剧增长，淮河也存在着水体污染问题。
3. 众所周知，水是生命之源，它孕育了地球上的一切生物，若没有水，地球将是一颗沉寂、荒凉的星球。作为我国的七大河之一，淮河的水量与水质，与无数人的健康、生命财产安全息息相关。在传统方式中，我们如果想要获取实时的水量、水质数据，可能需要到现场进行人工采集。在互联网技术时代，我们不必再那么麻烦了，只需要在相关地方建设水量、水质监测站。监测数据由监测设备自动采集，然后通过网络即时传送到相关的监测总站。如此一来，便保证了数据的及时性、准确性和有效性，同时大大地提高了效率。政府部门通过水量水质监测系统，可以更好地作出决策。环境工作者通过水量水质监测系统，可以及时地掌握环境的变化状况。普通群众通过水量水质监测系统，可以大概地知道险情，从而保障自身的生命财产安全。总而言之，开展水量水质监测，事关人类生存、经济发展、社会进步，是治国安邦的大事。
### 1.2 开发语言及环境
* 开发语言：java、javascript
* 开发环境：windows 10、IntelliJ IDEA 2018、Tomcat9.0.27、JDK 1.8
* 数据库:MySQL 5.6

### 1.3 系统所用到的技术
1.	后端：本系统后端的持久层技术使用的是Spring框架下的JdbcTemplate，web层和业务逻辑层没有使用框架，web层使用的是JAVA原生的Servlet API去编写的。数据库连接池技术使用的是阿里巴巴的druid。用到的JSON解析工具有jackson和fastjson，用于把数据变成json字符串响应给前台、解析中国环境监测总站返回来的json数据。用到的HTML解析器为JSoup，用于解析淮河水文局网站上的数据。

2.	前端：HTML、CSS、JavaScript、jQuery、Bootstrap、jQuery UI、OpenLayers、Echarts等等。

###	1.4 如何部署该项目
1. 因为是第一次上传项目到GitHub，所以还不是很熟练，为了方便，我直接git add . ，把IDEA编译生成的文件也一起上传上来了。项目的源码在“rivermodule”目录里面，其他目录可以不用理会。
2. 这是一个普通的web工程，不是Maven工程，所以部署项目时无需Maven环境。
3. 在IntelliJ IDEA中配置好Tomcat服务器就可以运行了，当然前提得有JDK环境。版本不要过低就行了，可以参考我使用的版本，也可以使用更高的版本。
4. 因为设置有过滤器Filter，所以没有登录是不能访问大部分的资源的。要想登录，需要把数据库创建出来，并创建相应的数据库表，保存有相应的用户记录才行。


## 2.更新日志
2020-01-19 

- 舍弃了昂贵的API接口，使用“中国环境监测总站”上面的数据，使得数据更加及时、准确和有效，最重要的是免费的！
- 修改了数据库表的结构，这就意味着后端的“三层架构”中的代码都需要修改，同时，前端的代码也需要修改。

2020-01-21 

- 经过很长时间的注释测试，终于修复了前端地图界面一个严重的bug：精准点击popup图标反而无法弹出信息，要点击图标下方一定距离区域才能弹出信息。
- 问题出现的原因：jQuerey UI框架的对话框导致的，把对话框直接放入地图中容器div中，则会出现此问题。
- 解决办法：把jQuery UI 对话框放到地图容器div外面。

 2020-02-03 

* 界面初始化时查询数据库，直接把所有的监测站显示在地图上，而不是用户点击一个按钮，就显示一个监测站在地图上。
* 每点击一个监测站，就获取点击位置的经纬度，把经纬度作为请求参数，向服务器发起Ajax请求。服务器响应回来监测站的信息以及对应的最新的水质数据信息，前台负责把拿到的json数据显示到界面上。
* 新增预警功能，可以把最近两天出现异常数据的监测站以特别地颜色显示在地图上。
* 可以在地图上绘制受污染的区域，并将这些区域的坐标字符串以文本的方式保存到数据库。前台也支持查询和删除受污染的区域。
* 优化了分页条，模仿百度分页条，做成“前5后4”的效果。

2020-02-04 

* 修复了在发起搜索之后，无法再查看实时水质信息的bug。经过对比分析，找出了问题出现的原因——直接选择table，然后调用jQuery的html()方法。改正的方法就是选择table的父元素div，再调用html()方法。
* 新增饼图和折线图。饼图可以直观的看出各类水质的占比，折线图则可以直观地看出水质的变化情况。

2020-02-07 

* 根据熵权G1法，从案例库中，计算与本次污染事件最相似的案例，如果相似度大于0.7，就显示出来，相似度按照从大到小的顺序排列。
* 添加了测量功能，可以测量距离、面积。

2020-02-08 12:10:49 

* 根据水质的类别，地图上的图标就显示不一样的颜色
* 实现的思路就是查询监测站表，查出所有的监测站，得出监测站的集合stationList，然后遍历该集合，根据监测站的名称查询水质表，取出最新的一条记录。然后将监测站和对应的一条水质数据结合，存入QualityAndStation的对象中，最后返回List<QualityAndStation> list即可。
* 难度主要是涉及到了两张表，需要将两张表相应的记录连接起来。有些监测站因为中国环境监测总站没有给出监测数据，所以查不到对应的水质记录。前端拿到后台发来的json数据，根据水质等级level的不同，采用不同颜色的图标即可。（这些图标的颜色利用Photoshop进行修改）


2020-02-10 

* 添加了下载数据的功能，可以下载最近七天的水位数据和水质数据。


2020-02-11 

* 添加了文件上传功能，可以上传水位数据文件和水质数据文件。可以用这种方式来保存数据到数据库，毕竟一条一条地输入数据的话，速度是比较慢的。
* 当然上传文件又用到了两个jar包，整个项目变得庞大了，这也就是普通web工程的缺点，如果是maven工程的话则不会存在这种问题。
* 用到的知识点主要是IO方面的知识，可以用缓冲字符输入流BufferedReader中特有的方法readLine()来读取文件中的一行数据，然后按照规则分割字符串，就得到了各个字段信息。同时为了解决中文乱码的问题，还用到到了转换流InputStreamReader，这个类在创建对象时，可以指定字符编码。

2020-02-14 

* 保证了数据的唯一性，站点相同，时间相同，就认为是同一条记录。
* 此次没有修改数据库表结构，根据前车之鉴，如果随意修改数据库表结构，将会牵扯到很多地方，需要进行大幅度的修改。主要是通过增加几行java代码，来保证数据的唯一性的。即在添加数据之前，根据站点名称和时间查询数据库，如果能查出来，说明记录已经存在，就不允许添加数据，这和注册用户有点类似，如果用户名存在，就不允许注册。
* 起初没有预料到会存在数据重复的问题，没有将站点名称和测量时间设为联合主键，只是单纯的把无实际意义的字段id设为主键，事实证明这并不能保证数据的唯一性，因为id是自动增长的，在添加记录的时候，无需输入id，那么连续输入同样的数据，也可以成功添加记录。


2020-02-15 

* 记录一件吓人的事情，今天我的电脑又差点开不开机了，尝试了十几次，最后在键盘灯亮起的那一刻，立马按住“ESC"键，按了好久，电脑屏幕终于亮起来了。早就预料到这样，所以才把项目托管到了github。现在是特殊时期，一直呆在乡下，如果坏了都没有地方维修。
* 本项目到今天为止吧，为了以防万一，得把论文可能会用到的程序界面截图保存到云端，还有数据库信息也要备份。

2020-03-18 

* 论文中期检查，根据老师的要求，添加了淮河流域的边界轮廓