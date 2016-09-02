![JSPatchUse](https://img.shields.io/badge/build-passing-green.svg)
![JSPatchUse](https://img.shields.io/badge/LICENSE-MIT-brightgreen.svg)

# JSPatchUse
 JSPatch 代码更新 使用学习


*****************
# 使用方法


### 步骤1：创建项目中导入JSPatch库

        切换到项目命令：
        cd /Users/..(项目地址)

        编辑或创建Podfile命令：
        vim Podfile

        【输入“i”进入编辑内容状态，添加：
        platform :ios, '6.0'
        pod 'JSPatch'
        粘贴后，按“esc”，输入“：”，再输入“wq”，回车】

        安装命令：
        pod install


### 步骤2：下载demo.js 文件到项目，修改AppDelegate.m文件：

        1、 #import "JPEngine.h"
        
        // Library/Caches
        #define FilePath ([[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil])

        /**
        *  下载JSPatch
        */
        -(void)loadJSPatch
        {
        //使用AFNetWork下载在服务器的js文件
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        NSURL *URL = [NSURL URLWithString:@"https://github.com/niexiaobo/JSPatchUse/blob/master/JSPatchUseDemo/JSPatchUseDemo/demo.js"];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response)
        {
        NSURL *documentsDirectoryURL = FilePath;
        //保存到本地 Library/Caches目录下
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        }
        completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error)
        {
        NSLog(@"File downloaded to: %@", filePath);
        }];
        [downloadTask resume];

        }

        /**
        *  运行下载的JS文件
        */
        -(void)HSDevaluateScript
        {

        //从本地获取下载的JS文件
        NSURL *p = FilePath;
        //获取内容
        NSString *js = [NSString stringWithContentsOfFile:[p.path stringByAppendingString:@"/demo.js"] encoding:NSUTF8StringEncoding error:nil];

        //如果有内容
        if (js.length > 0)
        {
        //-------
        //在此处解密js内容
        //----


        //运行
        [JPEngine startEngine];
        [JPEngine evaluateScript:js];
        }

        }
        //还是在AppDelegate中下面的两个方法内，进行下载服务器的js文件和运行下载后的js文件
        //加载配置
        - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
        {
        //可以在这里设置一个条件，比如隔多久才去请求一次服务器看看有没有可以下载的文件
        //以防止频繁请求
        [self loadJSPatch];

        return YES;
        }
        //应用程序进入活动状态时
        - (void)applicationDidBecomeActive:(UIApplication *)application
        {
        [self HSDevaluateScript];
        }

        2、这里使用到了JavaScriptcore核心库，所以还需要在General的Linded Framework and Libraries添加JavaScriptcore.framework 

### 步骤3：修复控制器的崩溃bug：

   ##### 控制器ViewController添加按钮，但是不写点击事件

        UIButton *crashBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 50)];
        [crashBtn setTitle:@"崩溃按钮" forState:UIControlStateNormal];
        [crashBtn addTarget:self action:@selector(crashBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [crashBtn setBackgroundColor:[UIColor grayColor]];
        [self.view addSubview:crashBtn];


        //崩溃按钮 的点击事件【崩溃测试，不写】，js里会重写此方法避免崩溃。
        //- (void)crashBtnClick:(id)sender.


   #####  demo.js里添加代码：1、重写crashBtnClick方法 2、跳转新建的JPTableViewController控制器

        //1、修改ViewController控制器的handleBtn方法（原控制器漏此方法，会导致崩溃）。

        defineClass('ViewController', {//defineClass：声明要被修改的控制器
        crashBtnClick: function(sender) { //声明要被修改或重写的方法
        var tableViewCtrl = JPTableViewController.alloc().init()
        self.navigationController().pushViewController_animated(tableViewCtrl, YES)
        },

        })

        //2、新建JPTableViewController控制器

        defineClass('JPTableViewController : UITableViewController <UIAlertViewDelegate>', ['data'], {
        dataSource: function() {
        var data = self.data();
        if (data) return data;
        var data = [];
        for (var i = 0; i < 20; i ++) {
        data.push("通过js创建的cell " + i);
        }
        self.setData(data)
        return data;
        },
        numberOfSectionsInTableView: function(tableView) {
        return 1;
        },
        tableView_numberOfRowsInSection: function(tableView, section) {
        return self.dataSource().length;
        },
        tableView_cellForRowAtIndexPath: function(tableView, indexPath) {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") 
        if (!cell) {
        cell = require('UITableViewCell').alloc().initWithStyle_reuseIdentifier(0, "cell")
        }
        cell.textLabel().setText(self.dataSource()[indexPath.row()])
        return cell
        },
        tableView_heightForRowAtIndexPath: function(tableView, indexPath) {
        return 60
        },
        tableView_didSelectRowAtIndexPath: function(tableView, indexPath) {
        var alertView = require('UIAlertView').alloc().initWithTitle_message_delegate_cancelButtonTitle_otherButtonTitles("Alert",self.dataSource()[indexPath.row()], self, "OK",  null);
        alertView.show()
        },
        alertView_willDismissWithButtonIndex: function(alertView, idx) {
        console.log('click btn ' + alertView.buttonTitleAtIndex(idx).toJS())
        }
        })


     #####  更新频率

我之前看到很多人把使用js和下载js的代码都放在了didFinishLaunchingWithOptions：这个方法。我觉得有所不妥，因为如果这个app用户一直放在手机的后台（比如微信），并且也没出现内存警告的话，这个方法应该一直不会调用。我建议的是：使用js文件的代码放在didFinishLaunchingWithOptions： 而下载js文件的代码放在applicationDidBecomeActive: 因为这个方法在程序启动和后台回到前台时都会调用。并且我建议设置一个间隔时间，根据一些数据和权衡之后我们采用的是间隔时间设为1小时。 也就是说每次来到这个方法时，先要检测是距离上次发请求的时间间隔是否超过1小时，超过则发请求，否则跳过。


### 步骤4：JSPatch OC-JS自动转换工具：https://github.com/bang590/JSPatchConvertor

        将这个文件，放在服务器上面，最好进行版本分类，这样在App下载的时候，就能根据当前的版本号来进行对应目录下的文件下载，例如：
        AppName-->2.1-->jspatch.js
        AppName-->2.2-->jspatch.js
        AppName-->2.3-->jspatch.js

        这样就能在App上根据目录：AppName(当前App版本号)\jspatch.js 这样的方式去下载对应版本的js文件了

*****************
      至此JSPatch在前端设置和使用差不多了。
*****************

### 步骤5：通过请求后台更新项目中demo.js补丁文件来达到动态修复项目Bug的功能。demo.js从后台下载后要加密存储到沙盒中。


    #####  demo.js的加密：
        在使用JSPatch时，JS脚本理论上可以调用任意OC方法，权限非常大，若经过HTTP传输时，被中间人攻击篡改js代码，则会造成很大危害。

        鉴于此种情况

            1. 服务器尽量使用https传输
            2. 对传输的代码做好加密和校验

PHP、iOS 使用JSPatch基本与RSA,AES加密：
http://www.jianshu.com/p/e6191c9e63c1


